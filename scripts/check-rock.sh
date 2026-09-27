#!/bin/sh
# Build the rock from the scm rockspec at the checked-out commit, install it
# into a temporary tree, and fail unless the installed rock ships
# plugin/meow-review.lua (REQ-0601). An install succeeds whether or not the
# runtime directories were copied, so only the installed files can show it.
set -eu

rockspec=${1:-meow.review.nvim-scm-1.rockspec}
tree=$(mktemp -d)
trap 'rm -rf "$tree"' EXIT

# `make` builds the working tree; `build` would fetch the rockspec's git
# source at main instead of the commit under test.
luarocks --lua-version 5.1 make --deps-mode none --tree "$tree" "$rockspec" >/dev/null

rock_dir=$(luarocks --lua-version 5.1 --tree "$tree" show --rock-dir meow.review.nvim)
if [ ! -f "$rock_dir/plugin/meow-review.lua" ]; then
    echo "check-rock: the installed rock has no plugin/meow-review.lua (looked in $rock_dir)" >&2
    exit 1
fi
echo "check-rock: $rock_dir/plugin/meow-review.lua is installed"
