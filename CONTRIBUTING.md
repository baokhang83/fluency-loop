## Contributing & support

Questions, ideas, and bug reports are welcome — open an
[issue](https://github.com/baokhang83/fluencyloop/issues) or start a
[discussion](https://github.com/baokhang83/fluencyloop/discussions).

<a id="project-status"></a>
**Status: beta.** FluencyLoop is actively dogfooded and the workflow is stable enough for daily
use. It stays on `0.x` while the skill and CLI surfaces settle, so expect fast-moving changes and
read the [changelog](CHANGELOG.md) before updating.

The scripts switch branches and write files in your repo, so they're tested. CI runs
[`shellcheck`](https://www.shellcheck.net/) + a [`bats`](https://github.com/bats-core/bats-core)
suite on every push and PR; run them locally with
`shellcheck -x -P SCRIPTDIR plugins/fluencyloop/scripts/bash/*.sh` and `bats tests`.

<a id="distribution-roadmap"></a>
> **Distribution:** FluencyLoop ships through its Claude Code and Codex marketplace plugins.
> The canonical runtime lives in `plugins/fluencyloop/`; do not add a machine-wide installer or
> copy skills into a user's agent directory.
