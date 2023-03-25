describe("php", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/php/test.php")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 3)
        assert.equals('tests/php/test.php:5:2:  function __construct($age) {', entries[1])
        assert.equals('tests/php/test.php:8:2:  function getAge() {', entries[2])
        assert.equals('tests/php/test.php:13:0:function newPerson($age) {', entries[3])
    end)

    it("callings", function()
        local entries = lens._get_captures({queries={"callings"}, bufids=buffers})

        assert.equals(#entries, 5)
        assert.equals('tests/php/test.php:17:0:$p = newPerson(42);', entries[1])
        assert.equals('tests/php/test.php:19:9:$num1 = $p->getAge();', entries[2])
    end)
end)
