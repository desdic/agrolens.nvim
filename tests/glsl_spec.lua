describe("glsl", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    vim.filetype.add({extension = {frag = "glsl", vert = "glsl"}})

    it("load", function()
        vim.cmd.edit("tests/glsl/default.frag")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "version"), "version")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries = core.get_captures({ queries = { "functions" }, bufids = buffers })

        -- functions
        eq(#entries, 4)
        eq(entries[1].filename, "tests/glsl/default.frag")
        eq(entries[1].lnum, 26)
        eq(entries[1].col, 0)
        eq(entries[1].line, "vec4 pointLight()")
        eq(entries[2].line, "vec4 direcLight()")
        eq(entries[3].line, "vec4 spotLight()")
        eq(entries[4].line, "void main()")
    end)
    it("callings", function()
        local entries = core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 1)
        eq(entries[1].filename, "tests/glsl/default.frag")
        eq(entries[1].lnum, 107)
        eq(entries[1].col, 2)
        eq(entries[1].line, "  FragColor = spotLight();")
    end)
    it("comments", function()
        local entries = core.get_captures({ queries = { "comments" }, bufids = buffers })
        eq(#entries, 23)
        eq(entries[1].filename, "tests/glsl/default.frag")
        eq(entries[1].lnum, 3)
        eq(entries[1].col, 0)
        eq(entries[1].line, "// Outputs colors in RGBA")
        eq(entries[23].line, "  /* outputs final color */")
    end)
end)
