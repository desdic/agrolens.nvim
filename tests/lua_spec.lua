describe("lua", function()
    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/lua/test.lua")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries = {"functions"}, bufids = buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({
            queries = {"functions"},
            bufids = buffers
        })

        -- functions
        assert.equals(#entries, 5)
        assert.equals("tests/lua/test.lua:1:0:local hello1 = function()",
                      entries[1])
        assert.equals("tests/lua/test.lua:5:0:hello2 = function()", entries[2])
        assert.equals("tests/lua/test.lua:9:0:function hello3()", entries[3])
        assert.equals("tests/lua/test.lua:19:0:M.hello4 = function()",
                      entries[4])
        assert.equals("tests/lua/test.lua:23:0:function M.hello5()", entries[5])
    end)

    it("callings", function()
        local entries = lens._get_captures({
            queries = {"callings"},
            bufids = buffers
        })

        assert.equals(#entries, 10)
        assert.equals('tests/lua/test.lua:2:4:    print("hello1")', entries[1])
        assert.equals('tests/lua/test.lua:6:4:    print("hello2")', entries[2])
    end)

    it("comments", function()
        local entries = lens._get_captures({
            queries = {"comments"},
            bufids = buffers
        })

        assert.equals(#entries, 2)
        assert.equals("tests/lua/test.lua:13:0:-- Local object", entries[1])
        assert.equals("tests/lua/test.lua:16:0:--[[", entries[2])
    end)
end)
