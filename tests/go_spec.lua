describe("go", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/go/main.go")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "package"), "package")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries = core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 4)
        eq(entries[1].filename, "tests/go/main.go")
        eq(entries[1].lnum, 15)
        eq(entries[1].col, 0)

        eq(entries[1].line, "func (p *Person) GetName() string {")
        eq(entries[2].line, "func print_person(p Person, fn format_func) {")
        eq(entries[3].line, "func main() {")
        eq(entries[4].line, "\tformat_func := func(p Person) string {")
    end)

    it("callings", function()
        local entries = core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 10)
        eq(entries[1].filename, "tests/go/main.go")
        eq(entries[1].lnum, 20)
        eq(entries[1].col, 2)

        eq(entries[1].line, "\tfmt.Println(fn(p))")
        eq(entries[2].line, "\tfmt.Println(fn(p))")
        eq(entries[3].line, '\t\ttt, err := time.Parse("01-02-2006", p.Born)')
        eq(entries[4].line, "\t\t\treturn err.Error()")
        eq(entries[5].line, "\t\tcurrentTime := time.Now()")
    end)

    it("comments", function()
        local entries = core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 2)
        eq(entries[1].filename, "tests/go/main.go")
        eq(entries[1].lnum, 26)
        eq(entries[1].col, 1)

        eq(entries[1].line, "\t/*")
        eq(entries[2].line, "\t// Print Donald")
    end)
end)
