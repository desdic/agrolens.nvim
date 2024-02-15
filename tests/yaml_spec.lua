describe("yaml", function()
    it("docker-compose", function()
        local lens = nil
        local buffers = nil

        vim.cmd.edit("tests/yaml/docker-compose.yml")
        buffers = vim.api.nvim_list_bufs()

        lens = require("telescope._extensions.agrolenslib")
        local entries = lens._get_captures({queries = {"docker-compose"}, bufids = buffers})

        assert.equals(#entries, 3)
        assert.equals("docker-compose.yml:4:2:  fakelookup:", entries[1])
        assert.equals("docker-compose.yml:9:2:  shell:", entries[2])
        assert.equals("docker-compose.yml:14:2:  test-runner:", entries[3])

        vim.cmd("%bdelete")
    end)
end)

describe("yaml2", function()
    it("github-workflow-steps", function()
        local lens = nil
        local buffers = nil

        vim.cmd.edit("tests/yaml/github-ci.yml")
        buffers = vim.api.nvim_list_bufs()

        lens = require("telescope._extensions.agrolenslib")
        local entries = lens._get_captures({queries = {"github-workflow-steps"}, bufids = buffers})

        assert.equals(#entries, 12)
        assert.equals("github-ci.yml:29:20:      - name: Checkout", entries[1])
        assert.equals("github-ci.yml:30:22:        uses: actions/checkout@v3", entries[2])
        assert.equals("github-ci.yml:32:20:      - name: Setup node", entries[3])
        assert.equals("github-ci.yml:33:22:        uses: actions/setup-node@v3", entries[4])
        assert.equals("github-ci.yml:38:20:      - name: Install", entries[5])
        assert.equals("github-ci.yml:39:21:        run: npm ci", entries[6])
    end)
end)
