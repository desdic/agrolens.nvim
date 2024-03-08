describe("rust", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/rust/src/main.rs")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "DateTime"), "DateTime")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries = core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 4)
        eq(entries[1].relfilename, "tests/rust/src/main.rs")
        eq(entries[1].lnum, 9)
        eq(entries[1].col, 4)

        eq(entries[1].line, "    fn calc_age_in_days(&self) -> i64 {")
        eq(entries[2].line, "    fn print(&self, f: fn(&Person) -> String) {")
        eq(entries[3].line, "fn format_person(p: &Person) -> String {")
        eq(entries[4].line, "fn main() {")
    end)

    it("callings", function()
        local entries = core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 7)
        eq(entries[1].relfilename, "tests/rust/src/main.rs")
        eq(entries[1].lnum, 10)
        eq(entries[1].col, 8)

        eq(entries[1].line, "        let today = Utc::now();")
        eq(entries[2].line, '            chrono::NaiveDate::parse_from_str(&self.born, "%d-%m-%Y")')
        eq(entries[3].line, "        today.signed_duration_since(borndate).num_days()")
        eq(entries[4].line, "    let age = p.calc_age_in_days();")
        eq(entries[5].line, '        name: "Donald Duck".to_string(),')
        eq(entries[6].line, '        born: "07-09-1934".to_string(),')
        eq(entries[7].line, "    donald.print(format_person);")
    end)

    it("comments", function()
        local entries = core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 2)
        eq(entries[1].relfilename, "tests/rust/src/main.rs")
        eq(entries[1].lnum, 27)
        eq(entries[1].col, 0)
        eq(entries[1].line, "/*")
        eq(entries[2].line, "    // Create Donald")
    end)
end)
