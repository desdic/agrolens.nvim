describe("ruby", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/ruby/test.rb")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 6)
        assert.equals('tests/ruby/test.rb:7:2:  attr_reader :born, :name', entries[1])
        assert.equals('tests/ruby/test.rb:9:2:  def initialize(born, name)', entries[2])
        assert.equals('tests/ruby/test.rb:15:0:def wrapped_string(dist)', entries[3])
        assert.equals('tests/ruby/test.rb:19:0:def to_string(dist)', entries[4])
        assert.equals('tests/ruby/test.rb:23:0:def print_intro', entries[5])
        assert.equals('tests/ruby/test.rb:27:0:def days_since_birth(born, convf = method(:wrapped_string))', entries[6])
    end)

    it("callings", function()
        local entries = lens._get_captures({queries={"callings"}, bufids=buffers})

        assert.equals(#entries, 14)
        assert.equals("tests/ruby/test.rb:3:0:require 'date'", entries[1])
        assert.equals("tests/ruby/test.rb:7:2:  attr_reader :born, :name", entries[2])
        assert.equals('tests/ruby/test.rb:16:8:  "[#{dist.to_i}]"', entries[3])
    end)
end)
