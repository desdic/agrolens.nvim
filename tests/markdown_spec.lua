describe("markdown", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/markdown/note.md")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"labels"}, bufids=buffers})
    end)

    it("labels", function()
        local entries = lens._get_captures({queries={"labels"}, bufids=buffers})

        -- labels
        assert.equals(#entries, 4)
        assert.equals("note.md:1:0:# Heading#1", entries[1])
        assert.equals("note.md:3:0:## Heading#2.1", entries[2])
        assert.equals("note.md:5:0:## Heading#2.2", entries[3])
        assert.equals("note.md:7:0:### Heading#3", entries[4])
    end)
end)
