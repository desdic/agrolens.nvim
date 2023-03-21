describe("toml", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/toml/test.toml")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"labels"}, bufids=buffers})
    end)

    it("labels", function()
        local entries = lens._get_captures({queries={"labels"}, bufids=buffers})

        assert.equals(#entries, 5)
        assert.equals("tests/toml/test.toml:5:0:[owner]", entries[1])
        assert.equals("tests/toml/test.toml:9:0:[database]", entries[2])
        assert.equals("tests/toml/test.toml:15:0:[servers]", entries[3])
        assert.equals("tests/toml/test.toml:17:0:[servers.alpha]", entries[4])
        assert.equals("tests/toml/test.toml:21:0:[servers.beta]", entries[5])
    end)
end)
