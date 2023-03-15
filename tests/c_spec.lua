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
        assert.equals(#entries, 3)

        assert.equals("void myfunc() {", entries[1].line)
        assert.equals("functions", entries[1]["agrolens.scope"].capture)
        assert.equals("void myfunc() {", entries[1]["agrolens.scope"].match)
        assert.equals("functions", entries[1]["agrolens.name"].capture)
        assert.equals("myfunc", entries[1]["agrolens.name"].match)
        --
        assert.equals("struct mystruct *myfunc2() {", entries[2].line)
        assert.equals("functions", entries[2]["agrolens.scope"].capture)
        assert.equals("functions", entries[2]["agrolens.name"].capture)
        assert.equals("myfunc2", entries[2]["agrolens.name"].match)

        assert.equals("int main() {", entries[3].line)
        assert.equals("functions", entries[3]["agrolens.scope"].capture)
        assert.equals("functions", entries[3]["agrolens.name"].capture)
        assert.equals("main", entries[3]["agrolens.name"].match)

    end)
end)
