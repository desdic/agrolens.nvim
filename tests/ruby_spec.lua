describe("ruby", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/ruby/test.rb")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "frozen_string_literal"), "frozen_string_literal")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries = core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 6)
        eq(entries[1].relfilename, "tests/ruby/test.rb")
        eq(entries[1].lnum, 7)
        eq(entries[1].col, 2)

        eq(entries[1].line, "  attr_reader :born, :name")
        eq(entries[2].line, "  def initialize(born, name)")
        eq(entries[3].line, "def wrapped_string(dist)")
        eq(entries[4].line, "def to_string(dist)")
        eq(entries[5].line, "def print_intro")
        eq(entries[6].line, "def days_since_birth(born, convf = method(:wrapped_string))")
    end)

    it("callings", function()
        local entries = core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 14)
        eq(entries[1].relfilename, "tests/ruby/test.rb")
        eq(entries[1].lnum, 3)
        eq(entries[1].col, 0)

        eq(entries[1].line, "require 'date'")
        eq(entries[2].line, "  attr_reader :born, :name")
        eq(entries[3].line, '  "[#{dist.to_i}]"')
    end)

    it("comments", function()
        local entries = core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 3)
        eq(entries[1].relfilename, "tests/ruby/test.rb")
        eq(entries[1].lnum, 1)
        eq(entries[1].col, 0)

        eq(entries[1].line, "# frozen_string_literal: true")
        eq(entries[2].line, "# A person")
        eq(entries[3].line, "=begin")
    end)
end)
