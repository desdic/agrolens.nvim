describe("yaml", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("docker-compose", function()
        vim.cmd.edit("tests/yaml/docker-compose.yml")
        buffers = vim.api.nvim_list_bufs()

        local entries = core.get_captures({ queries = { "docker-compose" }, bufids = buffers })

        eq(#entries, 3)
        eq(entries[1].filename, "tests/yaml/docker-compose.yml")
        eq(entries[1].lnum, 4)
        eq(entries[1].col, 2)

        eq(entries[1].line, "  fakelookup:")
        eq(entries[2].line, "  shell:")
        eq(entries[3].line, "  test-runner:")

        vim.cmd("%bdelete")
    end)
end)

describe("yaml2", function()
    it("github-workflow-steps", function()
        local core = require("agrolens.core")
        local buffers = nil
        local eq = assert.equals

        vim.cmd.edit("tests/yaml/github-ci.yml")
        buffers = vim.api.nvim_list_bufs()

        local entries = core.get_captures({ queries = { "github-workflow-steps" }, bufids = buffers })

        eq(#entries, 12)
        eq(entries[1].filename, "tests/yaml/github-ci.yml")
        eq(entries[1].lnum, 29)
        eq(entries[1].col, 20)

        eq(entries[1].line, "      - name: Checkout")
        eq(entries[2].line, "        uses: actions/checkout@v3")
        eq(entries[3].line, "      - name: Setup node")
        eq(entries[4].line, "        uses: actions/setup-node@v3")
        eq(entries[5].line, "      - name: Install")
        eq(entries[6].line, "        run: npm ci")
    end)
end)
