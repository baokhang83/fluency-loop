## Contributing & support

Questions, ideas, and bug reports are welcome — open an
[issue](https://github.com/baokhang83/fluencyloop/issues) or start a
[discussion](https://github.com/baokhang83/fluencyloop/discussions). This is alpha and
actively dogfooded, so expect rough edges and fast-moving changes.

The scripts switch branches and write files in your repo, so they're tested. CI runs
[`shellcheck`](https://www.shellcheck.net/) + a [`bats`](https://github.com/bats-core/bats-core)
suite on every push and PR; run them locally with `shellcheck -x -P SCRIPTDIR scripts/bash/*.sh`
and `bats tests`.

<a id="distribution-roadmap"></a>
> **Distribution roadmap:** today it's clone + `install.sh`. Packaging the skills as a Claude
> Code **plugin/marketplace** entry (one-click install for others) and publishing the CLI
> (homebrew/npm) are the next distribution steps — not required to use.
