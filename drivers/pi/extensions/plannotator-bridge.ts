/**
 * Plannotator Bridge — Pi Extension subsystem
 *
 * Optional/advisory bridge for PALS-owned review surfaces. This module talks to
 * Plannotator through the shared Pi event API only; it does not import
 * Plannotator internals, does not write `.paul/*` lifecycle artifacts, and does
 * not let Plannotator approve, route, or mutate PAUL lifecycle truth.
 *
 * Authority: Derived aid only. `savedPath` is advisory only; `agentSwitch` and
 * `permissionMode` are ignored; workflow prompts and sidecars are owned by later
 * Phase 286/287 workflow integration.
 */

import { readFileSync } from "fs";

export const PLANNOTATOR_REQUEST_CHANNEL = "plannotator:request";
export const PLANNOTATOR_REVIEW_RESULT_CHANNEL = "plannotator:review-result";

const DEFAULT_REQUEST_TIMEOUT_MS = 1_500;
const DEFAULT_REVIEW_TIMEOUT_MS = 5 * 60 * 1000;
const DEFAULT_STATUS_RETRY_DELAY_MS = 750;
const DEFAULT_STATUS_RETRY_LIMIT = 2;

type PlannotatorAction = "plan-review" | "review-status" | "code-review";

type PlannotatorResponse<T> =
  | { status: "handled"; result: T }
  | { status: "unavailable"; error?: string }
  | { status: "error"; error: string };

export type PlannotatorEvents = {
  emit?: (channel: string, payload: unknown) => void;
  on?: (channel: string, listener: (payload: unknown) => void) => unknown;
  off?: (channel: string, listener: (payload: unknown) => void) => void;
};

export type PlannotatorPiSurface = {
  events?: PlannotatorEvents;
};

export type PlanReviewRequest = {
  planFilePath: string;
  origin?: string;
  requestTimeoutMs?: number;
  reviewTimeoutMs?: number;
  statusRetryDelayMs?: number;
  statusRetryLimit?: number;
};

export type CodeReviewRequest = {
  diffType?: string;
  defaultBranch?: string;
  vcsType?: string;
  useLocal?: boolean;
  cwd?: string;
  prUrl?: string;
  requestTimeoutMs?: number;
};

export type NormalizedReviewDecision = {
  status: "approved" | "changes_requested";
  reviewId?: string;
  approved: boolean;
  feedback?: string;
  /** Advisory only. Never copy, rename, parse, or adopt `savedPath` as PLAN.md, SUMMARY.md, STATE.md, ROADMAP.md, or lifecycle truth. */
  savedPath?: string;
  /** Opaque advisory evidence only if a later workflow explicitly records it. */
  annotations?: unknown[];
};

export type PlannotatorBridgeResult =
  | ({ ok: true } & NormalizedReviewDecision)
  | {
      ok: false;
      status: "unavailable" | "error" | "timeout" | "abandoned" | "missing";
      reviewId?: string;
      error?: string;
      feedback?: string;
      savedPath?: string;
    };

type RequestEnvelope<TPayload> = {
  requestId: string;
  action: PlannotatorAction;
  payload: TPayload;
  respond: (response: PlannotatorResponse<unknown>) => void;
};

type PendingPlanReview = {
  status: "pending";
  reviewId: string;
};

type ReviewStatusResult =
  | { status: "pending" }
  | ({ status: "completed" } & RawReviewResultEvent)
  | { status: "missing" };

type RawReviewResultEvent = {
  reviewId?: string;
  approved?: boolean;
  feedback?: string;
  savedPath?: string;
  agentSwitch?: string;
  permissionMode?: string;
  annotations?: unknown[];
};

function randomRequestId(): string {
  return `pals-plannotator-${Date.now()}-${Math.random().toString(36).slice(2)}`;
}

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function normalizeDecision(raw: RawReviewResultEvent): PlannotatorBridgeResult {
  // `agentSwitch` and `permissionMode` are intentionally ignored. PALS owns
  // agent/skill routing and Pi/PALS permission posture.
  void raw.agentSwitch;
  void raw.permissionMode;

  if (typeof raw.approved !== "boolean") {
    return {
      ok: false,
      status: "error",
      reviewId: raw.reviewId,
      error: "Plannotator review result did not include a boolean approved field",
      feedback: raw.feedback,
      savedPath: raw.savedPath,
    };
  }

  return {
    ok: true,
    status: raw.approved ? "approved" : "changes_requested",
    reviewId: raw.reviewId,
    approved: raw.approved,
    feedback: raw.feedback,
    savedPath: raw.savedPath,
    annotations: raw.annotations,
  };
}

function hasEvents(pi: PlannotatorPiSurface): pi is { events: PlannotatorEvents } {
  return Boolean(pi.events && typeof pi.events.emit === "function");
}

async function requestThroughEvent<TPayload, TResult>(
  pi: PlannotatorPiSurface,
  action: PlannotatorAction,
  payload: TPayload,
  timeoutMs = DEFAULT_REQUEST_TIMEOUT_MS,
): Promise<PlannotatorResponse<TResult> | { status: "timeout" }> {
  if (!hasEvents(pi)) {
    return { status: "unavailable", error: "Pi event surface unavailable" };
  }

  return new Promise((resolve) => {
    let settled = false;
    const timer = setTimeout(() => {
      if (settled) return;
      settled = true;
      resolve({ status: "timeout" });
    }, timeoutMs);

    const envelope: RequestEnvelope<TPayload> = {
      requestId: randomRequestId(),
      action,
      payload,
      respond: (response) => {
        if (settled) return;
        settled = true;
        clearTimeout(timer);
        resolve(response as PlannotatorResponse<TResult>);
      },
    };

    try {
      pi.events?.emit?.(PLANNOTATOR_REQUEST_CHANNEL, envelope);
    } catch (error) {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      resolve({ status: "error", error: error instanceof Error ? error.message : String(error) });
    }
  });
}

function listenForReviewResult(
  pi: PlannotatorPiSurface,
  reviewId: string,
  timeoutMs: number,
): Promise<PlannotatorBridgeResult> {
  if (!pi.events || typeof pi.events.on !== "function") {
    return Promise.resolve({ ok: false, status: "unavailable", reviewId, error: "Pi event listener unavailable" });
  }

  return new Promise((resolve) => {
    let settled = false;
    const listener = (payload: unknown): void => {
      const result = payload as RawReviewResultEvent;
      if (result?.reviewId !== reviewId || settled) return;
      settled = true;
      cleanup();
      resolve(normalizeDecision(result));
    };
    const cleanup = (): void => {
      clearTimeout(timer);
      pi.events?.off?.(PLANNOTATOR_REVIEW_RESULT_CHANNEL, listener);
    };
    const timer = setTimeout(() => {
      if (settled) return;
      settled = true;
      cleanup();
      resolve({ ok: false, status: "timeout", reviewId, error: "Timed out waiting for plannotator:review-result" });
    }, timeoutMs);

    pi.events.on(PLANNOTATOR_REVIEW_RESULT_CHANNEL, listener);
  });
}

async function queryReviewStatus(
  pi: PlannotatorPiSurface,
  reviewId: string,
  requestTimeoutMs: number,
): Promise<PlannotatorBridgeResult | { ok: false; status: "pending" }> {
  const response = await requestThroughEvent<{ reviewId: string }, ReviewStatusResult>(
    pi,
    "review-status",
    { reviewId },
    requestTimeoutMs,
  );

  if (response.status === "timeout") {
    return { ok: false, status: "timeout", reviewId, error: "Timed out querying review-status" };
  }
  if (response.status === "unavailable") {
    return { ok: false, status: "unavailable", reviewId, error: response.error };
  }
  if (response.status === "error") {
    return { ok: false, status: "error", reviewId, error: response.error };
  }

  const result = response.result;
  if (result.status === "completed") {
    return normalizeDecision(result);
  }
  if (result.status === "missing") {
    return { ok: false, status: "missing", reviewId, error: "Plannotator review-status returned missing" };
  }
  return { ok: false, status: "pending" };
}

export async function awaitReviewResult(
  pi: PlannotatorPiSurface,
  reviewId: string,
  timeoutMs = DEFAULT_REVIEW_TIMEOUT_MS,
  options: { requestTimeoutMs?: number; statusRetryDelayMs?: number; statusRetryLimit?: number } = {},
): Promise<PlannotatorBridgeResult> {
  const eventResult = await listenForReviewResult(pi, reviewId, timeoutMs);
  if (eventResult.ok || eventResult.status !== "timeout") {
    return eventResult;
  }

  const requestTimeoutMs = options.requestTimeoutMs ?? DEFAULT_REQUEST_TIMEOUT_MS;
  const statusRetryDelayMs = options.statusRetryDelayMs ?? DEFAULT_STATUS_RETRY_DELAY_MS;
  const statusRetryLimit = options.statusRetryLimit ?? DEFAULT_STATUS_RETRY_LIMIT;

  for (let attempt = 0; attempt <= statusRetryLimit; attempt += 1) {
    const statusResult = await queryReviewStatus(pi, reviewId, requestTimeoutMs);
    if (statusResult.ok || statusResult.status !== "pending") {
      return statusResult as PlannotatorBridgeResult;
    }
    if (attempt < statusRetryLimit) {
      await delay(statusRetryDelayMs);
    }
  }

  return {
    ok: false,
    status: "abandoned",
    reviewId,
    error: "Plannotator UI remained pending after bounded review-status retry; classified as abandoned, not approved",
  };
}

export async function requestPlanReview(
  pi: PlannotatorPiSurface,
  request: PlanReviewRequest,
): Promise<PlannotatorBridgeResult> {
  const planContent = readFileSync(request.planFilePath, "utf-8");
  const requestTimeoutMs = request.requestTimeoutMs ?? DEFAULT_REQUEST_TIMEOUT_MS;
  const response = await requestThroughEvent<
    { planFilePath?: string; planContent: string; origin?: string },
    PendingPlanReview
  >(
    pi,
    "plan-review",
    {
      planFilePath: request.planFilePath,
      planContent,
      origin: request.origin ?? "pals",
    },
    requestTimeoutMs,
  );

  if (response.status === "timeout") {
    return { ok: false, status: "unavailable", error: "No Plannotator listener responded before timeout" };
  }
  if (response.status === "unavailable") {
    return { ok: false, status: "unavailable", error: response.error };
  }
  if (response.status === "error") {
    return { ok: false, status: "error", error: response.error };
  }

  const reviewId = response.result?.reviewId;
  if (!reviewId) {
    return { ok: false, status: "error", error: "Plannotator plan-review did not return a reviewId" };
  }

  return awaitReviewResult(pi, reviewId, request.reviewTimeoutMs ?? DEFAULT_REVIEW_TIMEOUT_MS, {
    requestTimeoutMs,
    statusRetryDelayMs: request.statusRetryDelayMs,
    statusRetryLimit: request.statusRetryLimit,
  });
}

export async function requestCodeReview(
  pi: PlannotatorPiSurface,
  request: CodeReviewRequest = {},
): Promise<PlannotatorBridgeResult> {
  const response = await requestThroughEvent<Record<string, unknown>, RawReviewResultEvent>(
    pi,
    "code-review",
    {
      diffType: request.diffType,
      defaultBranch: request.defaultBranch,
      vcsType: request.vcsType,
      useLocal: request.useLocal,
      cwd: request.cwd,
      prUrl: request.prUrl,
    },
    request.requestTimeoutMs ?? DEFAULT_REQUEST_TIMEOUT_MS,
  );

  if (response.status === "timeout") {
    return { ok: false, status: "unavailable", error: "No Plannotator listener responded before timeout" };
  }
  if (response.status === "unavailable") {
    return { ok: false, status: "unavailable", error: response.error };
  }
  if (response.status === "error") {
    return { ok: false, status: "error", error: response.error };
  }

  return normalizeDecision(response.result);
}

// No-op Pi extension factory
export default function (_pi: unknown): void {}
