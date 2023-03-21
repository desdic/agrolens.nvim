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
end)
