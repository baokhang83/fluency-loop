#!/usr/bin/env bats
# slice-context.sh — the current slice's hunks + metadata (token-cheap review input).

load test_helper

setup() {
    setup_initialized_repo
    printf 'a\nb\n' > app.txt
    git add -A && git commit -q -m "seed app + fluencyloop init"
    bash "$BIN/new-feature.sh" "add caching" >/dev/null
}

json() { bash "$BIN/slice-context.sh" --json; }

@test "slice-context --json returns valid JSON with hunks + metadata" {
    printf 'a\nb changed\nc\n' > app.txt
    run json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c '
import json,sys
d=json.load(sys.stdin)
for k in ("feature","base_kind","base","files_changed","insertions","deletions","files","untracked","diff"):
    assert k in d, k
assert "b changed" in d["diff"], d["diff"]
'
}

@test "includes tracked edits + untracked files; excludes FluencyLoop's own paths" {
    printf 'a\nb changed\n' > app.txt
    printf 'x\n' > new.txt          # untracked
    run json
    echo "$output" | python3 -c '
import json,sys
d=json.load(sys.stdin)
paths=[f["path"] for f in d["files"]]
assert "app.txt" in paths, paths
assert d["untracked"]==["new.txt"], d["untracked"]
assert not any(".fluencyloop" in p or "docs/fluencyloop" in p for p in paths+d["untracked"]), d
'
}

@test "base_kind is base-ref before any journaled session" {
    printf 'a\nb changed\n' > app.txt
    [ "$(json | python3 -c 'import json,sys;print(json.load(sys.stdin)["base_kind"])')" = "base-ref" ]
}

@test "after a journaled session, the slice scopes to changes since it" {
    printf 'a\nb\nc\n' > app.txt
    bash "$BIN/new-session.sh" --slug add-caching "slice one" >/dev/null
    git add -A && git commit -q -m "slice one + journal"
    printf 'a\nb\nc\nd\n' > app.txt          # second slice
    run json
    [ "$(echo "$output" | python3 -c 'import json,sys;print(json.load(sys.stdin)["base_kind"])')" = "last-session" ]
    echo "$output" | python3 -c 'import json,sys;d=json.load(sys.stdin);assert "+d" in d["diff"], d["diff"]'
}

@test "plain form prints a header and the diff" {
    printf 'a\nb changed\n' > app.txt
    run bash "$BIN/slice-context.sh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Slice context"* ]]
    [[ "$output" == *"b changed"* ]]
}
