describe("php", function()
    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("test.php")
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

        assert.equals(#entries, 3)
        assert.equals("test.php:6:2:  function __construct($age) {",
                      entries[1])
        assert.equals("test.php:9:2:  function getAge() {", entries[2])
        assert.equals("test.php:14:0:function newPerson($age) {",
                      entries[3])
    end)

    it("callings", function()
        local entries = lens._get_captures({
            queries = {"callings"},
            bufids = buffers
        })

        assert.equals(#entries, 5)
        assert.equals("test.php:21:0:$p = newPerson(42);", entries[1])
        assert.equals("test.php:23:9:$num1 = $p->getAge();",
                      entries[2])
    end)

    it("comments", function()
        local entries = lens._get_captures({
            queries = {"comments"},
            bufids = buffers
        })

        assert.equals(#entries, 2)
        assert.equals("test.php:3:0:// A person", entries[1])
        assert.equals("test.php:18:0:/*", entries[2])
    end)
end)
