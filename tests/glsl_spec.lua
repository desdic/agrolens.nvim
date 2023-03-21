describe("glsl", function()

    local lens = nil
    local buffers = nil

    vim.filetype.add({extension = {frag = "glsl", vert = "glsl"}})

    it("load", function()
        vim.cmd.edit("tests/glsl/default.frag")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        -- functions
        assert.equals(#entries, 4)
        assert.equals("tests/glsl/default.frag:26:0:vec4 pointLight()", entries[1])
        assert.equals("tests/glsl/default.frag:55:0:vec4 direcLight()", entries[2])
        assert.equals("tests/glsl/default.frag:75:0:vec4 spotLight()", entries[3])
        assert.equals("tests/glsl/default.frag:104:0:void main()", entries[4])

    end)
end)