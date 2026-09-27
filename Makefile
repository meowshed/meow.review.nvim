# Makefile for meow.review.nvim
# Requires: nvim (>= 0.11), stylua, luacheck, lua-language-server, luarocks
# Optional:  luarocks (for bootstrapping busted/nlua)

.PHONY: all test lint format format-check check build deps clean

NVIM      ?= nvim
STYLUA    ?= stylua
LUACHECK  ?= luacheck
NLUA      ?= $(HOME)/.luarocks/bin/nlua
LUALS     ?= lua-language-server
LUAROCKS  ?= luarocks

# The newest rockspec in the root, which is the release being prepared
ROCKSPEC  := $(shell ls meow.review.nvim-*.rockspec | sort -V | tail -n 1)

LUA_FILES := lua/**/*.lua lua/**/**/*.lua plugin/*.lua tests/**/*.lua scripts/*.lua

# ── Bootstrap test dependencies ───────────────────────────────────────────────

## Install busted + nlua into the user luarocks tree (Lua 5.1)
deps:
	luarocks --lua-version 5.1 --local install busted
	luarocks --lua-version 5.1 --local install nlua

# ── Primary targets ───────────────────────────────────────────────────────────

all: format-check lint check test build

## Run the busted test suite via nlua (Neovim as Lua interpreter)
test:
	$(NLUA) scripts/run_busted.lua \
		--output TAP \
		tests/spec/

## Run luacheck static analysis
lint:
	$(LUACHECK) lua/ plugin/ tests/ scripts/ --config .luacheckrc

## Format all Lua source files with stylua (modifies in place)
format:
	$(STYLUA) lua/ plugin/ tests/ scripts/

## Check formatting without modifying files (CI-safe)
format-check:
	$(STYLUA) --check lua/ plugin/ tests/ scripts/

## Type-check lua/ and plugin/ with lua-language-server against Neovim's runtime
check:
	@export VIMRUNTIME="$$($(NVIM) --clean --headless +'lua io.write(vim.env.VIMRUNTIME)' +q 2>&1)"; \
	for dir in lua plugin; do \
		$(LUALS) --check="$$dir" --checklevel=Warning --configpath="$(CURDIR)/.luarc.json" || exit 1; \
	done

## Build and install the newest rockspec into build/ (no network: dependencies are skipped)
build:
	$(LUAROCKS) --lua-version 5.1 make --deps-mode none --tree build/ $(ROCKSPEC)

# ── Housekeeping ─────────────────────────────────────────────────────────────

clean:
	rm -rf test-results/ coverage/ deps/ build/
