describe("python", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/python/test.py")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 3)
        assert.equals("tests/python/test.py:10:4:    def hello(self):", entries[1])
        assert.equals("tests/python/test.py:14:0:def hello():", entries[2])
        assert.equals("tests/python/test.py:18:0:def main():", entries[3])
    end)
end)
