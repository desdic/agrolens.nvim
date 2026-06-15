local core = require("agrolens.core")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

T["yaml"] = MiniTest.new_set({
    hooks = {
        pre_once = function()
            vim.cmd("silent! %bwipeout!")
        end,
    },
})

T["yaml"]["docker-compose"] = function()
    vim.cmd.edit("tests/yaml/docker-compose.yml")
    local buffers = vim.api.nvim_list_bufs()

    local entries = core.get_captures({ queries = { "docker-compose" }, bufids = buffers })

    eq(#entries, 3)
    eq(entries[1].relfilename, "tests/yaml/docker-compose.yml")
    eq(entries[1].lnum, 4)
    eq(entries[1].col, 2)

    eq(entries[1].line, "  fakelookup:")
    eq(entries[2].line, "  shell:")
    eq(entries[3].line, "  test-runner:")

    vim.cmd("%bdelete")
end

T["yaml2"] = MiniTest.new_set({
    hooks = {
        pre_once = function()
            vim.cmd("silent! %bwipeout!")
        end,
    },
})

T["yaml2"]["github-workflow-steps"] = function()
    vim.cmd.edit("tests/yaml/github-ci.yml")
    local buffers = vim.api.nvim_list_bufs()

    local entries = core.get_captures({ queries = { "github-workflow-steps" }, bufids = buffers })

    eq(#entries, 12)
    eq(entries[1].relfilename, "tests/yaml/github-ci.yml")
    eq(entries[1].lnum, 29)
    eq(entries[1].col, 20)

    eq(entries[1].line, "      - name: Checkout")
    eq(entries[2].line, "        uses: actions/checkout@v3")
    eq(entries[3].line, "      - name: Setup node")
    eq(entries[4].line, "        uses: actions/setup-node@v3")
    eq(entries[5].line, "      - name: Install")
    eq(entries[6].line, "        run: npm ci")
end

return T
