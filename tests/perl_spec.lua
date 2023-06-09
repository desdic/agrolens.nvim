describe("perl", function()
    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/perl/perl.pl")
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

        -- functions
        assert.equals(#entries, 2)
        assert.equals("tests/perl/perl.pl:3:0:sub Hello {", entries[1])
        assert.equals("tests/perl/perl.pl:10:0:sub HelloParam {", entries[2])
    end)

    it("callings", function()
        local entries = lens._get_captures({
            queries = {"callings"},
            bufids = buffers
        })

        assert.equals(#entries, 4)
        assert.equals('tests/perl/perl.pl:4:3:   print "Hello, World!\\n";',
                      entries[1])
        assert.equals('tests/perl/perl.pl:12:3:   print "Hello, @param!\\n";',
                      entries[2])
        assert.equals("tests/perl/perl.pl:15:0:Hello();", entries[3])
        assert.equals('tests/perl/perl.pl:16:0:HelloParam("friend");',
                      entries[4])
    end)

    it("comments", function()
        local entries = lens._get_captures({
            queries = {"comments"},
            bufids = buffers
        })

        assert.equals(#entries, 2)
        assert.equals("tests/perl/perl.pl:1:0:#!/usr/bin/perl", entries[1])
        assert.equals("tests/perl/perl.pl:7:0:=for comment", entries[2])
    end)
end)
