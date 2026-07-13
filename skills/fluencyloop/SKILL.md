---
name: fluencyloop
description: 'FluencyLoop — stay fluent in code as AI writes it. Router/overview for the per-feature loop (design → build+teach → review), the optional up-front planning stage for large chunks, the woven-in constitution that grows from decisions, plus post-merge backfill. Use when the user mentions FluencyLoop, "fluency", the .fluencyloop/ directory, or wants to set up / understand the workflow but hasn''t named a specific stage.'
---

# FluencyLoop

*The code and your fluency in it are produced together, or not at all.*

FluencyLoop keeps the people behind a codebase fluent in it as AI writes more of it. At its core
is a **per-feature loop** — design → build (teach) → review — driven by whoever is building.
Nothing gates a merge; work that skips the loop is caught after merge by backfill.

```
PER BIG CHUNK (optional)     REPEATS, PER FEATURE (contributor-driven)
( plan )                  →  design    →  build (teach)   →  review
architecture + roadmap       diagrams     session journal    PR view assembles itself
```

Planning is **optional** — reach for it only when a chunk of work is too big for one
feature/branch and needs an architecture + roadmap first. Small work goes straight to
**fluencyloop-feature**.

The **constitution** (the project's checkable principles) is load-bearing — plan and feature both
check designs against it — but it is **not a stage you sit down and author**. It's born from your
first real intent (a plan, or the first feature as backstop) and grows as features harvest
repeatable stances from real decisions. Same law as the journal and the calibration profile: it
**accretes from building**, never authored cold unless you explicitly choose to.

## Route to the right stage

| The user wants to…                                   | Skill                  |
|------------------------------------------------------|------------------------|
| Plan a large chunk — architecture, task breakdown, roadmap | **fluencyloop-plan**  |
| Start building something, stay fluent as they go     | **fluencyloop-feature**    |
| Prepare a PR / summarise a feature for a reviewer     | **fluencyloop-review**     |
| Document work that shipped without the loop           | **fluencyloop-backfill**   |

If the user just says "fluency" or "set up FluencyLoop" and `.fluencyloop/` does not exist yet,
run `fluencyloop init` (it scaffolds the state + an **empty** constitution stub), then go to
**fluencyloop-feature** (or **fluencyloop-plan** for a big chunk) — the constitution fills itself
in from there.

## Initialise a project

```bash
<fluencyloop-dist>/scripts/bash/init.sh   # scaffolds .fluencyloop/ and installs these skills
```

This creates `.fluencyloop/` (scripts, templates, constitution stub) and copies the skills into
`.claude/skills`. A feature is a branch (`feature/<slug>`); sessions are committed journals;
the per-developer calibration profile lives globally in `~/.fluencyloop/` and is never
committed.

## The four standing principles

- **Evidence over pitch** — probe demand cheaply before building.
- **Stay out of the way** — never block the fast path; flag exposure, don't gate.
- **The developer stays the architect** — the tool serves their authorship.
- **Honest about tradeoffs** — no claim of free comprehension.
