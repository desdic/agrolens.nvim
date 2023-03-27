describe("go", function()
    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/go/main.go")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries = {"functions"}, bufids = buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries = {"functions"}, bufids = buffers})

        assert.equals(#entries, 4)

        assert.equals("tests/go/main.go:15:0:func (p *Person) GetName() string {", entries[1])
        assert.equals("tests/go/main.go:19:0:func print_person(p Person, fn format_func) {", entries[2])
        assert.equals("tests/go/main.go:23:0:func main() {", entries[3])
        assert.equals("tests/go/main.go:29:1:\tformat_func := func(p Person) string {", entries[4])
    end)

    it("callings", function()
        local entries = lens._get_captures({queries = {"callings"}, bufids = buffers})

        assert.equals(#entries, 10)

        assert.equals("tests/go/main.go:20:2:\tfmt.Println(fn(p))", entries[1])
        assert.equals("tests/go/main.go:20:1:\tfmt.Println(fn(p))", entries[2])
        assert.equals('tests/go/main.go:30:15:\t\ttt, err := time.Parse("01-02-2006", p.Born)', entries[3])
        assert.equals("tests/go/main.go:32:13:\t\t\treturn err.Error()", entries[4])
        assert.equals("tests/go/main.go:35:19:\t\tcurrentTime := time.Now()", entries[5])
    end)

    it("comments", function()
        local entries = lens._get_captures({queries = {"comments"}, bufids = buffers})

        assert.equals(#entries, 2)

        assert.equals("tests/go/main.go:26:1:\t/*", entries[1])
        assert.equals("tests/go/main.go:41:1:\t// Print Donald", entries[2])
    end)
end)
