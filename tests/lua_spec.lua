describe("lua", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/lua/test.lua")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "hello1"), "hello1")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries =
            core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 6)
        eq(entries[1].relfilename, "tests/lua/test.lua")
        eq(entries[1].lnum, 1)
        eq(entries[1].col, 0)
        eq(entries[1].line, "local hello1 = function()")
        eq(entries[2].line, "hello2 = function()")
        eq(entries[3].line, "function hello3()")
        eq(entries[4].line, "M.hello4 = function()")
        eq(entries[5].line, "function M.hello5()")
        eq(entries[6].line, "function M:hello6()")
    end)

    it("callings", function()
        local entries =
            core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 12)
        eq(entries[1].relfilename, "tests/lua/test.lua")
        eq(entries[1].lnum, 2)
        eq(entries[1].col, 4)
        eq(entries[1].line, '    print("hello1")')
        eq(entries[2].line, '    print("hello2")')
        eq(entries[12].line, 'M:hello6()')
    end)

    it("comments", function()
        local entries =
            core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 2)
        eq(entries[1].relfilename, "tests/lua/test.lua")
        eq(entries[1].lnum, 13)
        eq(entries[1].col, 0)
        eq(entries[1].line, "-- Local object")
        eq(entries[2].line, "--[[")
    end)
end)
