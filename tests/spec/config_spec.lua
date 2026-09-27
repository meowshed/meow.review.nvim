-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev <me@retran.me>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @file: tests/spec/config_spec.lua
-- @brief: Tests for lua/meow/review/config/internal.lua
-- @author: Andrew Vasilyev
-- @license: MIT
--
-- Run with: make test

local assert = require("luassert")

describe("meow.review.config.internal", function()
    local config

    before_each(function()
        package.loaded["meow.review.config.internal"] = nil
        vim.g.meow_review = nil
        config = require("meow.review.config.internal")
    end)

    describe("get()", function()
        it("returns defaults when no user config is set", function()
            local cfg = config.get()
            assert.equal(3, cfg.context_lines)
            assert.equal("clipboard", cfg.default_exporter)
            assert.equal(".review.md", cfg.export_filename)
            assert.equal(".cache/meow-review/annotations.json", cfg.store_path)
            assert.same({}, cfg.disabled_exporters)
            assert.equal(64, cfg.modal_width)
            assert.equal(6, cfg.modal_height)
            assert.equal("<C-t>", cfg.modal_cycle_key)
        end)
        it("merges user config over defaults", function()
            vim.g.meow_review = { context_lines = 5, default_exporter = "file" }
            package.loaded["meow.review.config.internal"] = nil
            local cfg = require("meow.review.config.internal").get()
            assert.equal(5, cfg.context_lines)
            assert.equal("file", cfg.default_exporter)
            -- untouched defaults survive
            assert.equal(".review.md", cfg.export_filename)
        end)

        it("supports a callable vim.g.meow_review", function()
            vim.g.meow_review = function()
                return { context_lines = 10 }
            end
            package.loaded["meow.review.config.internal"] = nil
            local cfg = require("meow.review.config.internal").get()
            assert.equal(10, cfg.context_lines)
        end)

        it("falls back to defaults on invalid user config", function()
            vim.g.meow_review = { context_lines = "not_a_number" }
            package.loaded["meow.review.config.internal"] = nil
            local cfg = require("meow.review.config.internal").get()
            -- should fall back to default (3), not crash
            assert.equal(3, cfg.context_lines)
        end)
    end)

    describe("validate()", function()
        it("returns true for a valid config", function()
            local ok, err = config.validate({
                context_lines = 3,
                disabled_exporters = {},
                default_exporter = "clipboard",
                default_formatter = "markdown",
                export_filename = ".md",
                store_path = "path",
                modal_width = 64,
                modal_height = 6,
                modal_cycle_key = "<C-t>",
                prompt_preamble = "text",
                export_summary = true,
            })
            assert.is_true(ok)
            assert.is_nil(err)
        end)

        it("returns false for wrong type on context_lines", function()
            local ok, err = config.validate({
                context_lines = "bad",
                disabled_exporters = {},
                default_exporter = "clipboard",
                default_formatter = "markdown",
                export_filename = ".md",
                store_path = "path",
                modal_width = 64,
                modal_height = 6,
                modal_cycle_key = "<C-t>",
                prompt_preamble = "text",
                export_summary = true,
            })
            assert.is_false(ok)
            assert.is_string(err)
        end)

        it("returns false for wrong type on modal_width", function()
            local ok, err = config.validate({
                context_lines = 3,
                disabled_exporters = {},
                default_exporter = "clipboard",
                default_formatter = "markdown",
                export_filename = ".md",
                store_path = "path",
                modal_width = "wide",
                modal_height = 6,
                modal_cycle_key = "<C-t>",
                prompt_preamble = "text",
                export_summary = true,
            })
            assert.is_false(ok)
            assert.is_string(err)
        end)
    end)
end)
