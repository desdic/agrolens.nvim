describe("docker-compose.yml", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/yaml/docker-compose.yml")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"labels"}, bufids=buffers})
    end)

    it("labels", function()
        local entries = lens._get_captures({queries={"labels"}, bufids=buffers})

        -- labels
        assert.equals(#entries, 3)
        assert.equals("tests/yaml/docker-compose.yml:4:2:  fakelookup:", entries[1])
        assert.equals("tests/yaml/docker-compose.yml:9:2:  shell:", entries[2])
        assert.equals("tests/yaml/docker-compose.yml:14:2:  test-runner:", entries[3])
    end)
end)
