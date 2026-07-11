<img width="1983" height="793" alt="image" src="https://github.com/user-attachments/assets/84b171e0-98ed-4fdc-9198-1aadfc35d369" />

The code and your fluency in it are produced together, or not at all. See
[MANIFESTO.md](MANIFESTO.md) for the why.

FluencyLoop is a four-stage workflow, delivered as coding-agent **skills** + deterministic
**bash scripts** + committed **state** in `.fluencyloop/` — the same three-layer shape as
SpecKit, aimed at the opposite point on the timeline (during & after code, not before).

```
ONCE, PER PROJECT        REPEATS, PER FEATURE (contributor-driven)
constitution          →  design      →  build (teach)   →  review
(maintainer)             diagrams        session journal    PR view assembles itself
```

Nothing gates a merge. Work that skips the loop is caught **after** merge by `backfill`.

## Install

**1. Once per machine** — from a clone of this repo:

```bash
git clone https://github.com/baokhang83/fluencyloop && cd fluencyloop
./install.sh
```

This copies the tool into `~/.fluencyloop/lib`, puts the `fluencyloop` CLI on your PATH
(`~/.local/bin`), and installs the interactive skills **user-wide** (`~/.claude/skills`) so
your coding agent sees them in every project. (`./install.sh --no-skills` skips the last
step; `--bin-dir <dir>` changes where the CLI is linked.)

**2. Once per project** — inside a repo you want to use FluencyLoop on:

```bash
fluencyloop init
```

This scaffolds that repo's `.fluencyloop/` state (scripts, templates, a constitution stub) and
adds the calibration `.gitignore` guard. Skills are already user-wide, so they are *not*
copied into the repo — unless you want contributors to get them on clone, in which case:

```bash
fluencyloop init --vendor-skills   # commits the skills into the repo's .claude/skills
```

> Distribution roadmap: today it's clone + `install.sh`. Packaging the skills as a Claude
> Code **plugin/marketplace** entry (one-click install for others) and publishing the CLI
> (homebrew/npm) are the next distribution steps — not required to use or dogfood it.

## Use it

| Stage | Slash command (in your agent) | Or the CLI directly |
|-------|-------------------------------|---------------------|
| 1. Constitution *(maintainer, once)* | `/fluencyloop-constitution` | — |
| 2–3. Feature: design → build + teach *(per feature)* | `/fluencyloop-feature` | `fluencyloop feature "<intent>"` |
| 4. Review *(per feature)* | `/fluencyloop-review` | `fluencyloop review` |
| Safety net *(post-merge)* | `/fluencyloop-backfill` | — |

You invoke a stage two ways: **type the slash command** (e.g. `/fluencyloop-feature`), or just
**describe the task** ("start a feature to add rate limiting") and your agent triggers the
matching skill from its description. Both run the same skill.

The **skills** carry the interactive, calibrated behaviour (teaching at slice boundaries,
one-question-at-a-time constitution authoring). The **scripts** carry the deterministic
plumbing (branches, files, PR-view assembly) so the journal is reliable rather than
left to the model.

## Layout

```
install.sh                  machine install: CLI on PATH + skills user-wide
fluency                     CLI dispatcher (init / feature / session / review)
scripts/bash/               deterministic plumbing (common, init, new-feature, …)
templates/                  .fluencyloop state templates (constitution, design, session)
skills/                     the interactive skills (installed into ~/.claude/skills)
MANIFESTO.md                the why
```

## Key rules baked in

- **A feature is a branch** (`feature/<slug>`) — the PR view assembles itself, no manual
  linking; session files store no commit SHAs.
- **Never gate.** Flag exposure and unverified trust; never block building or merging.
- **Sessions describe the work, not the person.** The `trust:` marker is about a decision's
  verification state, never an author's competence.
- **Calibration is per-developer and global** (`~/.fluencyloop/`), never committed.
