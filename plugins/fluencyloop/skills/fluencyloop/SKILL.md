---
name: fluencyloop
description: 'FluencyLoop — stay fluent in code as AI writes it. Router/overview for the per-feature loop (design → build+teach → review), the optional up-front planning stage for large chunks, the woven-in constitution that grows from decisions, plus post-merge backfill. Use when the user mentions FluencyLoop, "fluency", the .fluencyloop/ directory, or wants to set up / understand the workflow but hasn''t named a specific stage.'
---

# FluencyLoop

*The code and your fluency in it are produced together, or not at all.*

## Bundled CLI (Codex)

The CLI is bundled with this plugin, two directories above this loaded `SKILL.md`. For every
`fluencyloop …` command, invoke that dispatcher directly from the loaded skill path. On native
Windows, invoke the adjacent `fluencyloop.ps1` with `pwsh`.

This is internal packaging. Do not search for a global `fluencyloop` installation, browse the
web, set or explain an environment variable for the skill path, or describe how the dispatcher
was found. For a literal
`fluencyloop …` request, run it immediately and return the result concisely.

## Question delivery

FluencyLoop's stage skills use **`AskUserQuestion` in Claude Code** for genuine prompts. Codex
has no equivalent question-form tool, so they ask a concise standalone question in chat and pause
for the answer before continuing.

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
**`$fluencyloop:feature`**.

The **constitution** (the project's checkable principles) is load-bearing — plan and feature both
check designs against it — but it is **not a stage you sit down and author**. It's born from your
first real intent (a plan, or the first feature as backstop) and grows as features harvest
repeatable stances from real decisions. Same law as the journal and the calibration profile: it
**accretes from building**, never authored cold unless you explicitly choose to.

## Route to the right stage

| The user wants to…                                   | Skill                  |
|------------------------------------------------------|------------------------|
| Plan a large chunk — architecture, task breakdown, roadmap | **`$fluencyloop:plan`**  |
| Start building something, stay fluent as they go     | **`$fluencyloop:feature`**    |
| Prepare a PR / summarise a feature for a reviewer     | **`$fluencyloop:review`**     |
| Document work that shipped without the loop           | **`$fluencyloop:backfill`**   |

If the user just says "fluency" or "set up FluencyLoop" and `.fluencyloop/` does not exist yet,
run the bundled `fluencyloop init` without asking (it initialises Git when needed and scaffolds the
state + an **empty** constitution stub), then go to
**`$fluencyloop:feature`** (or **`$fluencyloop:plan`** for a big chunk) — the constitution fills itself
in from there.

## Initialise a project

```bash
fluencyloop init   # initialises Git if needed, then scaffolds .fluencyloop/
```

This creates `.fluencyloop/` (scripts, templates, constitution stub). Agent skills are activated
through the agent's installation mechanism and are never copied into the project. A feature is a branch (`feature/<slug>`); sessions are committed journals;
the per-developer calibration profile lives globally in `~/.fluencyloop/` and is never
committed.

## Minimal generation — scripts assemble, the model writes the *why*

FluencyLoop is cheap to run because the deterministic scripts do everything mechanical and the
model spends tokens only on the irreducible rationale. The split, per stage:

| Stage | The scripts assemble (deterministic) | The model writes (irreducible) |
|-------|--------------------------------------|--------------------------------|
| **Declare / design** | feature branch, `design.md` stub, `state.json` (slug / branch / stage / base) | the design diagrams (the shapes), the constitution check |
| **Build (per slice)** | `slice-context` (diff + metadata + `likely_decision`), the session skeleton, the **decision blocks** (`fluencyloop decision`), `calibration signal` / `compact`, `state.json` updates | the code, the taught **why**, knowledge-transfer prose, the decision field *values* |
| **Review** | `assemble-pr-view` (sessions inlined, commit range, base), PR creation | the reviewer-facing distillation |
| **Backfill** | feature + session scaffold, `state.json`, decision blocks, `check` drift | the reconstructed rationale (marked `unverified`) |

The rule: if a stage asks the model to produce something a script could assemble deterministically
— a file skeleton, a commit range, a formatted block, a state read — that's a bug; move it to a
script. The model's tokens go to the *why*, never to plumbing.

## The four standing principles

- **Evidence over pitch** — probe demand cheaply before building.
- **Stay out of the way** — never block the fast path; flag exposure, don't gate.
- **The developer stays the architect** — the tool serves their authorship.
- **Honest about tradeoffs** — no claim of free comprehension.
