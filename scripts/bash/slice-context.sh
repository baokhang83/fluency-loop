#!/usr/bin/env bash
# slice-context.sh — the changed hunks + metadata for the current slice, so the model identifies
# decisions from the diff instead of re-reading whole files (token-cheap). The slice is everything
# since the last journaled session (the last commit touching the feature's sessions dir), or the
# feature's base ref if none yet, through the working tree — including untracked files.
#
# Usage: slice-context.sh [--json]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

require_fluency
cd "$(repo_root)"   # normalize pathspecs to the repo root regardless of where we're invoked

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

# The slice is the developer's CODE, not FluencyLoop's own bookkeeping — exclude the tool's paths.
EXCLUDE=(-- . ':!.fluencyloop' ':!docs/fluencyloop')

FEATURE="$(state_get feature)"; [ -z "$FEATURE" ] && FEATURE="$(current_feature_slug)"
BASE_REF="$(state_get base_ref)"; [ -z "$BASE_REF" ] && BASE_REF="main"

# Where the slice starts: the last journaled session, else the feature's base ref, else HEAD.
SINCE=""; BASE_KIND="base-ref"
if [ -n "$FEATURE" ]; then
    SDIR="$(feature_path "$FEATURE")/sessions"
    LAST_JOURNAL="$(git log -1 --format=%H -- "$SDIR" 2>/dev/null || true)"
    [ -n "$LAST_JOURNAL" ] && { SINCE="$LAST_JOURNAL"; BASE_KIND="last-session"; }
fi
[ -z "$SINCE" ] && SINCE="$BASE_REF"
if ! git rev-parse --verify --quiet "$SINCE" >/dev/null 2>&1; then
    SINCE="HEAD"; BASE_KIND="head"
fi

# Untracked files are part of the slice — render each as an added-file diff (no index changes).
untracked_diff() {
    git ls-files --others --exclude-standard -z "${EXCLUDE[@]}" | while IFS= read -r -d '' f; do
        git diff --no-index -- /dev/null "$f" 2>/dev/null || true
    done
}

DIFF="$( git diff "$SINCE" "${EXCLUDE[@]}"; untracked_diff )"

read -r INS DEL TRACKED_FILES <<EOF
$(git diff --numstat "$SINCE" "${EXCLUDE[@]}" | awk '{i+=($1=="-"?0:$1); d+=($2=="-"?0:$2); n++} END{print i+0, d+0, n+0}')
EOF
UNTRACKED_COUNT="$(git ls-files --others --exclude-standard "${EXCLUDE[@]}" | awk 'END{print NR+0}')"
FILES_CHANGED=$((TRACKED_FILES + UNTRACKED_COUNT))
SHORT="$(git rev-parse --short "$SINCE" 2>/dev/null || printf '%s' "$SINCE")"

if $JSON_MODE; then
    files="$(git diff --name-status "$SINCE" "${EXCLUDE[@]}" | awk -F'\t' '
        NF>=2 { p=$NF; gsub(/\\/,"\\\\",p); gsub(/"/,"\\\"",p)
                printf "%s{\"status\":\"%s\",\"path\":\"%s\"}", (n++?",":""), $1, p }')"
    untracked="$(git ls-files --others --exclude-standard "${EXCLUDE[@]}" | awk '
        { p=$0; gsub(/\\/,"\\\\",p); gsub(/"/,"\\\"",p); printf "%s\"%s\"", (n++?",":""), p }')"
    # JSON-escape the diff text (backslash, quote, tab, CR; newlines join records).
    diff_esc="$(printf '%s' "$DIFF" | awk '
        { s=$0; gsub(/\\/,"\\\\",s); gsub(/"/,"\\\"",s); gsub(/\t/,"\\t",s); gsub(/\r/,"\\r",s)
          printf "%s%s", (NR>1?"\\n":""), s }')"
    printf '{"feature":"%s","base_kind":"%s","base":"%s","files_changed":%s,"insertions":%s,"deletions":%s,"files":[%s],"untracked":[%s],"diff":"%s"}\n' \
        "$(json_escape "$FEATURE")" "$BASE_KIND" "$(json_escape "$SHORT")" \
        "$FILES_CHANGED" "$INS" "$DEL" "$files" "$untracked" "$diff_esc"
else
    echo "# Slice context — feature: ${FEATURE:-<none>} (since $BASE_KIND $SHORT)"
    echo "# $FILES_CHANGED file(s), +$INS -$DEL"
    echo
    printf '%s\n' "$DIFF"
fi
