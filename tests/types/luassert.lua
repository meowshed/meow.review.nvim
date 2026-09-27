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
-- @file: tests/types/luassert.lua
-- @brief: Adds luassert's optional failure message to the bundled LuaLS types.
-- @author: Andrew Vasilyev
-- @license: MIT
--
-- Every luassert assertion accepts a message as its last argument, but the
-- luassert library shipped with lua-language-server declares only the value.

---@meta

---@class luassert.internal
local internal = {}

---@param value any
---@param message? string Shown when the assertion fails.
function internal.truthy(value, message) end

---@param value any
---@param message? string Shown when the assertion fails.
function internal.falsy(value, message) end

---@param value any
---@param message? string Shown when the assertion fails.
function internal.is_nil(value, message) end

return internal
