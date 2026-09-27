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
-- @file: scripts/run_busted.lua
-- @brief: Patches package.path for luarocks-installed busted, then runs busted.
-- @author: Andrew Vasilyev
-- @license: MIT
--
-- Wrapper: patches package.path so Neovim's LuaJIT can find the luarocks-
-- installed busted/luassert modules, then delegates to the busted runner.
--
-- Usage (via nlua):
--   nlua scripts/run_busted.lua [busted args...]

-- Inject the user luarocks tree for Lua 5.1
local luarocks_tree = vim.fn.expand("~/.luarocks/share/lua/5.1")
package.path = luarocks_tree .. "/?.lua;" .. luarocks_tree .. "/?/init.lua;" .. package.path

local cluarocks_tree = vim.fn.expand("~/.luarocks/lib/lua/5.1")
package.cpath = cluarocks_tree .. "/?.so;" .. package.cpath

-- Inject the plugin root so require("meow.review.*") resolves
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(root)

-- nui.nvim: required runtime dependency
local nui_path = root .. "/deps/nui.nvim"
if vim.fn.isdirectory(nui_path) == 0 then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--depth=1",
        "https://github.com/MunifTanjim/nui.nvim",
        nui_path,
    })
end
vim.opt.rtp:prepend(nui_path)

-- Forward remaining args as busted args
local busted_args = {}
for i = 1, #arg do
    table.insert(busted_args, arg[i])
end

-- Run busted programmatically
local busted_runner = require("busted.runner")

-- busted.runner expects the CLI args in _G.arg
_G.arg = busted_args

busted_runner({ standalone = false })
