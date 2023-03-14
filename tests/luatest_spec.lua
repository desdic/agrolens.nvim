describe("lua", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/lua/test.lua")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        local plenary = require "plenary"
        lens = require("telescope._extensions.agrolenslib")
        local log = plenary.log.new({plugin = "agrolens", level = "info"})
        lens.setup(log)
        lens._get_captures({commands={"functions"}, buffers=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({commands={"functions"}, buffers=buffers})

        -- We should have found 3 functions
        assert.equals(#entries, 3)

        assert.equals("local hello1 = function()", entries[1].line)
        assert.equals("functions", entries[1].rcapture.capture)
        assert.equals("local hello1 = function()", entries[1].rcapture.match)
        assert.equals("functions", entries[1].rname.capture)
        assert.equals("hello1", entries[1].rname.match)

        assert.equals("hello2 = function()", entries[2].line)
        assert.equals("functions", entries[2].rcapture.capture)
        -- assert.equals("local hello1 = function()", entries[2].rcapture.match)
        assert.equals("functions", entries[2].rname.capture)
        assert.equals("hello2", entries[2].rname.match)

        assert.equals("function hello3()", entries[3].line)
        assert.equals("functions", entries[3].rcapture.capture)
        -- assert.equals("local hello1 = function()", entries[2].rcapture.match)
        assert.equals("functions", entries[3].rname.capture)
        assert.equals("hello3", entries[3].rname.match)
    end)

    it("methods", function()
        local entries = lens._get_captures({commands={"methods"}, buffers=buffers})

        -- We should have found 2 methods
        assert.equals(#entries, 2)

        assert.equals("M.hello4 = function()", entries[1].line)
        assert.equals("methods", entries[1].rcapture.capture)
        -- assert.equals("local hello1 = function()", entries[1].rcapture.match)
        assert.equals("methods", entries[1].rname.capture)
        assert.equals("hello4", entries[1].rname.match)
    end)
end)
