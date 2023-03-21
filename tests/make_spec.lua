describe("make", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/make/Makefile")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"labels"}, bufids=buffers})
    end)

    it("labels", function()
        local entries = lens._get_captures({queries={"labels"}, bufids=buffers})

        -- labels
        assert.equals(#entries, 5)
        assert.equals("tests/make/Makefile:1:0:.PHONY: all", entries[1])
        assert.equals("tests/make/Makefile:3:0:all: lint test", entries[2])
        assert.equals("tests/make/Makefile:5:0:test:", entries[3])
        assert.equals("tests/make/Makefile:8:0:lint:", entries[4])
        assert.equals("tests/make/Makefile:11:0:docgen:", entries[5])
    end)
end)
