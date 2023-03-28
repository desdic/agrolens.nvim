describe("python", function()
    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/python/test.py")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries = {"functions"}, bufids = buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({
            queries = {"functions"},
            bufids = buffers
        })

        assert.equals(#entries, 4)
        assert.equals(
            "tests/python/test.py:11:4:    def __init__(self, name: str, born: str):",
            entries[1])
        assert.equals("tests/python/test.py:15:4:    def print(self, format):",
                      entries[2])
        assert.equals("tests/python/test.py:20:0:def format(p: Person) -> str:",
                      entries[3])
        assert.equals("tests/python/test.py:32:0:def main():", entries[4])
    end)

    it("callings", function()
        local entries = lens._get_captures({
            queries = {"callings"},
            bufids = buffers
        })

        assert.equals(#entries, 6)
        assert.equals("tests/python/test.py:16:8:        print(format(self))",
                      entries[1])
        assert.equals(
            'tests/python/test.py:24:19:    borndate = datetime.strptime(p.born, "%d-%m-%Y")',
            entries[2])
        assert.equals("tests/python/test.py:25:14:    now = datetime.today()",
                      entries[3])
        assert.equals(
            'tests/python/test.py:34:4:    donald = Person(name="Donald Duck", born="07-09-1934")',
            entries[4])
        assert.equals("tests/python/test.py:35:8:    donald.print(format)",
                      entries[5])
        assert.equals("tests/python/test.py:39:4:    main()", entries[6])
    end)
    it("comments", function()
        local entries = lens._get_captures({
            queries = {"comments"},
            bufids = buffers
        })

        assert.equals(#entries, 4)
        assert.equals("tests/python/test.py:1:0:#!/usr/bin/env python3",
                      entries[1])
        assert.equals('tests/python/test.py:3:0:"""', entries[2])
        assert.equals('tests/python/test.py:21:8:    """', entries[3])
        assert.equals("tests/python/test.py:33:4:    # Create Donald",
                      entries[4])
    end)
end)
