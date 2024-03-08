describe("python", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/python/test.py")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "python3"), "python3")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries =
            core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 4)
        eq(entries[1].relfilename, "tests/python/test.py")
        eq(entries[1].lnum, 11)
        eq(entries[1].col, 4)

        eq(entries[1].line, "    def __init__(self, name: str, born: str):")
        eq(entries[2].line, "    def print(self, format):")
        eq(entries[3].line, "def format(p: Person) -> str:")
        eq(entries[4].line, "def main():")
    end)

    it("callings", function()
        local entries =
            core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 6)
        eq(entries[1].lnum, 16)
        eq(entries[1].col, 8)

        eq(entries[1].line, "        print(format(self))")
        eq(entries[2].line, '    borndate = datetime.strptime(p.born, "%d-%m-%Y")')
        eq(entries[3].line, "    now = datetime.today()")
        eq(entries[4].line, '    donald = Person(name="Donald Duck", born="07-09-1934")')
        eq(entries[5].line, "    donald.print(format)")
        eq(entries[6].line, "    main()")
    end)
    it("comments", function()
        local entries =
            core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 4)
        eq(entries[1].lnum, 1)
        eq(entries[1].col, 0)

        eq(entries[1].line, "#!/usr/bin/env python3")
        eq(entries[2].line, '"""')
        eq(entries[3].line, '    """')
        eq(entries[4].line, "    # Create Donald")
    end)
end)
