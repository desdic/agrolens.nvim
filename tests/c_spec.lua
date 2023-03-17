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
        lens.get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens.get_captures({queries={"functions"}, bufids=buffers})

        -- We should have found 3 functions
        assert.equals(#entries, 3)

        assert.equals("tests/c/test.c:7:0:void myfunc() {", entries[1])
        assert.equals("tests/c/test.c:11:0:struct mystruct *myfunc2() {", entries[2])
        assert.equals("tests/c/test.c:15:0:int main() {", entries[3])
    end)
end)
