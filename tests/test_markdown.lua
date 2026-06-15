local core = require("agrolens.core")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set({
    hooks = {
        pre_once = function()
            vim.cmd("silent! %bwipeout!")
        end,
    },
})

local buffers = nil

T["load"] = function()
    vim.cmd.edit("tests/markdown/note.md")
    buffers = vim.api.nvim_list_bufs()
    eq(#buffers, 1)

    local content = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

    -- make sure buffer has content
    eq(string.match(content[1], "Heading"), "Heading")

    core.get_captures({ queries = { "labels" }, bufids = buffers })
end

T["labels"] = function()
    local entries = core.get_captures({ queries = { "labels" }, bufids = buffers })

    eq(#entries, 4)
    eq(entries[1].relfilename, "tests/markdown/note.md")
    eq(entries[1].lnum, 1)
    eq(entries[1].col, 0)
    eq(entries[1].line, "# Heading#1")
    eq(entries[2].line, "## Heading#2.1")
    eq(entries[3].line, "## Heading#2.2")
    eq(entries[4].line, "### Heading#3")
end

return T
