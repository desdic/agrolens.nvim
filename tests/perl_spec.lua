describe("perl", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/perl/perl.pl")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        -- functions
        assert.equals(#entries, 2)
        assert.equals("tests/perl/perl.pl:3:0:sub Hello {", entries[1])
        assert.equals("tests/perl/perl.pl:7:0:sub HelloParam {", entries[2])
    end)
end)
