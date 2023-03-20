describe("c", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/c/test.c")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        -- We should have found 3 functions
        assert.equals(#entries, 3)

        assert.equals("tests/c/test.c:7:0:void myfunc() {", entries[1])
        assert.equals("tests/c/test.c:11:0:struct mystruct *myfunc2() {", entries[2])
        assert.equals("tests/c/test.c:15:0:int main() {", entries[3])
    end)
end)
