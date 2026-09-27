#!/bin/sh
# Fail if any rockspec revision of the given version of meow.review.nvim is
# already on luarocks.org, so a published version is never replaced
# (REQ-0605). `luarocks search` exits 0 whether or not it finds the version,
# and also when it can't reach the server, so this reads its output and fails
# closed when the search itself failed.
set -eu

version=${1:?usage: check-unpublished.sh X.Y.Z}
server=${LUAROCKS_SERVER:-https://luarocks.org}
err=$(mktemp)
trap 'rm -f "$err"' EXIT

if ! out=$(luarocks --only-server="$server" search --porcelain meow.review.nvim "$version" 2>"$err"); then
    echo "check-unpublished: the search on $server failed:" >&2
    cat "$err" >&2
    exit 1
fi
if grep -q 'Failed searching manifest' "$err"; then
    echo "check-unpublished: the search couldn't reach $server:" >&2
    cat "$err" >&2
    exit 1
fi

# --porcelain prints one tab-separated line per file: name, version, kind, server.
published=$(printf '%s\n' "$out" | awk -F '\t' -v v="$version" \
    '$1 == "meow.review.nvim" && index($2, v "-") == 1 && substr($2, length(v) + 2) ~ /^[0-9]+$/ { print $2 }' | sort -u)
if [ -n "$published" ]; then
    echo "check-unpublished: meow.review.nvim $version is already on $server as $(printf '%s' "$published" | tr '\n' ' ')" >&2
    exit 1
fi
echo "check-unpublished: no revision of meow.review.nvim $version is on $server"
