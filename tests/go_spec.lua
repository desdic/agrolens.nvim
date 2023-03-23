describe("go", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/go/main.go")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        -- We should have found 3 functions
        assert.equals(#entries, 3)

        assert.equals("tests/go/main.go:9:0:func (p *Person) GetAge() int {", entries[1])
        assert.equals("tests/go/main.go:13:0:func ret42() int {", entries[2])
        assert.equals("tests/go/main.go:17:0:func main() {", entries[3])
    end)

    it("calling", function()
        local entries = lens._get_captures({queries={"calling"}, bufids=buffers})

        assert.equals(#entries, 5)

        assert.equals("tests/go/main.go:18:1:\tnum := ret42()", entries[1])
        assert.equals("tests/go/main.go:21:10:\tnum2 := p.GetAge()", entries[2])
        assert.equals("tests/go/main.go:23:1:\tret42()", entries[3])
        assert.equals("tests/go/main.go:24:2:\tp.GetAge()", entries[4])
        assert.equals("tests/go/main.go:26:2:\tfmt.Println(num, num2)", entries[5])
    end)
end)
