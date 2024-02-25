describe("make", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals


    it("load", function()
        vim.cmd.edit("tests/make/Makefile")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "all"), "all")

        core.get_captures({ queries = { "labels" }, bufids = buffers })
    end)

    it("labels", function()
        local entries = core.get_captures({ queries = { "labels" }, bufids = buffers })

        eq(#entries, 5)
        eq(entries[1].filename, "tests/make/Makefile")
        eq(entries[1].lnum, 1)
        eq(entries[1].col, 0)
        eq(entries[1].line, ".PHONY: all")
        eq(entries[2].line, "all: lint test")
        eq(entries[3].line, "test:")
        eq(entries[4].line, "lint:")
        eq(entries[5].line, "docgen:")
    end)
end)
