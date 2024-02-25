describe("php", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/php/test.php")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "php"), "php")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries = core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 3)
        eq(entries[1].filename, "tests/php/test.php")
        eq(entries[1].lnum, 6)
        eq(entries[1].col, 2)

        eq(entries[1].line, "  function __construct($age) {")
        eq(entries[2].line, "  function getAge() {")
        eq(entries[3].line, "function newPerson($age) {")
    end)

    it("callings", function()
        local entries = core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 5)
        eq(entries[1].filename, "tests/php/test.php")
        eq(entries[1].lnum, 21)
        eq(entries[1].col, 0)

        eq(entries[1].line, "$p = newPerson(42);")
        eq(entries[2].line, "$num1 = $p->getAge();")
    end)

    it("comments", function()
        local entries = core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 2)
        eq(entries[1].filename, "tests/php/test.php")
        eq(entries[1].lnum, 3)
        eq(entries[1].col, 0)

        eq(entries[1].line, "// A person")
        eq(entries[2].line, "/*")
    end)
end)
