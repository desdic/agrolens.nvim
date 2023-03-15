describe("c", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/c/test.c")
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
        assert.equals(#entries, 2)

        assert.equals("void myfunc() {", entries[1].line)
        assert.equals("functions", entries[1].rcapture.capture)
        assert.equals("void myfunc() {", entries[1].rcapture.match)
        assert.equals("functions", entries[1].rname.capture)
        assert.equals("myfunc", entries[1].rname.match)

        assert.equals("int main() {", entries[2].line)
        assert.equals("functions", entries[2].rcapture.capture)
        assert.equals("functions", entries[2].rname.capture)
        assert.equals("main", entries[2].rname.match)

    end)
end)
