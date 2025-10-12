describe("groovy", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/groovy/test.groovy")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "tests"), "tests")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries =
            core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 1)
        eq(entries[1].relfilename, "tests/groovy/test.groovy")
        eq(entries[1].lnum, 29)
        eq(entries[1].col, 4)

        eq(entries[1].line, "    void printPerson() {")
    end)

    it("callings", function()
        local entries =
            core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 6)
        eq(entries[1].lnum, 19)
        eq(entries[1].col, 4)

        eq(entries[1].line, "    Person(String name, String born) {")
        eq(entries[2].line, "        def now = LocalDate.now()")
        eq(entries[3].line, '        def borndate = LocalDate.parse(this.born, java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"))')
        eq(entries[4].line, '        println( "${this.name} is ${days} days old")')
        eq(entries[5].line, 'Person donald = new Person("Donald Duck", "07-09-1934")')
        eq(entries[6].line, "donald.printPerson()")
    end)
    it("comments", function()
        local entries =
            core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 4)
        eq(entries[1].lnum, 6)
        eq(entries[1].col, 4)

        eq(entries[1].line, " * Groovy implementation of person")
        eq(entries[2].line, "     * Constructor of Person")
        eq(entries[3].line, "     * Prints how old Person is")
        eq(entries[4].line, "// Create Donald")
    end)
end)
