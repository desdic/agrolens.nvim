describe("rust", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/rust/main.rs")
        buffers = vim.api.nvim_list_bufs()

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 3)
        assert.equals("tests/rust/main.rs:7:4:    fn get_age(&self) -> String {", entries[1])
        assert.equals("tests/rust/main.rs:12:0:fn get_num(n: u32) -> String {", entries[2])
        assert.equals("tests/rust/main.rs:16:0:fn main() {", entries[3])
    end)

    it("callings", function()
        local entries = lens._get_captures({queries={"callings"}, bufids=buffers})

        assert.equals(#entries, 3)
        assert.equals('tests/rust/main.rs:13:4:    return n.to_string();', entries[1])
        assert.equals('tests/rust/main.rs:20:4:    get_num(43);', entries[2])
        assert.equals('tests/rust/main.rs:21:4:    p.get_age();', entries[3])
    end)
end)
