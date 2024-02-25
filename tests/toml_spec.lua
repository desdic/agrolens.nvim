describe("toml", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/toml/test.toml")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "document"), "document")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("labels", function()
        local entries = core.get_captures({ queries = { "labels" }, bufids = buffers })

        eq(#entries, 5)
        eq(entries[1].filename, "tests/toml/test.toml")
        eq(entries[1].lnum, 5)
        eq(entries[1].col, 0)

        eq(entries[1].line, "[owner]")
        eq(entries[2].line, "[database]")
        eq(entries[3].line, "[servers]")
        eq(entries[4].line, "[servers.alpha]")
        eq(entries[5].line, "[servers.beta]")
    end)
end)
