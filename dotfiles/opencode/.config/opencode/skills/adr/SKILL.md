---
name: adr
description: Consult and maintain Architecture Decision Records under docs/adr/. Use before work that touches project structure, new dependencies, data models, API contracts, or choosing between design patterns, and when creating or updating such records.
---

# ADR protocol

Keep one lightweight Architecture Decision Record per significant decision.

## Consult first

- Before architecture-affecting work, glob `docs/adr/*.md` and read the records that could be touched.
- Respect `Status: Superseded by NNNN` — read the superseding record.

## Create when

- New dependency, or removing a structural one.
- Data model or API contract change.
- Choosing between design patterns/approaches.
- Any change to repo layout or system boundaries.
- Any change to a public interface or cross-cutting utility that other code depends on — these always need an ADR and user sign-off.

## Location & naming

- `docs/adr/NNNN-short-title.md`
- `NNNN` = next number after the highest existing (or `0001`).
- Title is a short hyphenated slug, e.g. `0002-use-sqlite-for-food-cache.md`.

## Template

# NNNN. Title

- **Status:** Proposed | Accepted | Superseded by NNNN
- **Date:** YYYY-MM-DD

## Context

The problem or requirement forcing a decision.

## Decision

The chosen approach.

## Consequences

- **Positive:** benefits.
- **Negative/Risks:** trade-offs or tech debt.

## Lifecycle

- Mark `Proposed` → `Accepted` once implemented.
- Mark `Superseded by NNNN` when replaced.
- Keep each section a few lines. Update only the ADRs you are touching.
