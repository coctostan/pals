# Pi-Native Implementation Findings

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 197 — v2.45 Findings Triage |
| Artifact status | Planning input for Phases 198-201 |
| Implementation status | No implementation approved by this artifact |

## Purpose

This document triages the completed v2.45 Pi-native architecture work into implementation-planning inputs. It is not a build plan and does not authorize runtime, workflow, validation-script, dependency, or legacy-surface changes.

The goal is to preserve v2.45 evidence in a compact, source-cited form so v2.46 can design workstreams, sequencing, validation evidence, and the final executable implementation roadmap before implementation hardening begins.

## Source Inputs

| Source | Evidence used | Planning implication |
|---|---|---|
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Final v2.45 proposal, target architecture, authority boundaries, promoted/rejected patterns, migration roadmap, implementation roadmap, validation classes, readiness checklist. | Primary source for implementation-planning scope. |
| `docs/PI-NATIVE-SUPPORT-INVENTORY.md` | Phase 192 support-tier reset: Pi active supported runtime; Claude Code and Agent SDK frozen legacy/historical; `.paul/*` remains authoritative. | Workstreams should optimize for Pi without reopening active cross-harness parity. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Phase 193 Pi primitive inventory: command routing, installed resources, lifecycle UI, context injection, guided UX, module visibility, CARL, helper-agent delegation, GitHub Flow surfacing. | Workstreams should map implementation ideas to existing Pi primitives before adding new surfaces. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Phase 194 context-cost model, read/citation contract, assistance components, rejected designs, spike backlog, and recommended sequence. | Workstreams need source citations, freshness, bounded output, and full-read fallback as first-class requirements. |
| `.paul/phases/195-exploratory-pi-native-spikes/195-01-SUMMARY.md` | Phase 195 artifact-slice spike implementation and validation evidence: source-cited, freshness-marked, activation-gated, read-only slices passed Pi 186/186 and cross-harness 100/100. | Artifact-slice loading is the only proven implementation-grade pattern so far. |
| `.paul/phases/196-final-pi-native-architecture-proposal/196-01-SUMMARY.md` | Phase 196 closure decisions: promote artifact slices first, classify validation by support purpose, keep architecture closure separate from implementation. | v2.46 should plan implementation before starting build hardening. |
| `.paul/PROJECT.md`, `.paul/STATE.md`, `.paul/ROADMAP.md` | Current lifecycle truth, active requirements, v2.46 phase route, and PLAN/APPLY/UNIFY state. | Later plans must preserve artifact-first lifecycle authority and current milestone routing. |

## Planning-Only Boundary

This triage artifact may guide later plans, but it does not approve implementation. Future implementation still requires normal PLAN approval, APPLY execution, module dispatch, validation evidence, GitHub Flow gates, UNIFY reconciliation, and `.paul/*` lifecycle writes.
