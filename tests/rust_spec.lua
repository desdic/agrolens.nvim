describe("rust", function()
    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/rust/src/main.rs")
        buffers = vim.api.nvim_list_bufs()

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries = {"functions"}, bufids = buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({
            queries = {"functions"},
            bufids = buffers
        })

        assert.equals(#entries, 4)
        assert.equals(
            "tests/rust/src/main.rs:9:4:    fn calc_age_in_days(&self) -> i64 {",
            entries[1])
        assert.equals(
            "tests/rust/src/main.rs:22:4:    fn print(&self, f: fn(&Person) -> String) {",
            entries[2])
        assert.equals(
            "tests/rust/src/main.rs:30:0:fn format_person(p: &Person) -> String {",
            entries[3])
        assert.equals("tests/rust/src/main.rs:36:0:fn main() {", entries[4])
    end)

    it("callings", function()
        local entries = lens._get_captures({
            queries = {"callings"},
            bufids = buffers
        })

        assert.equals(#entries, 7)
        assert.equals(
            "tests/rust/src/main.rs:10:8:        let today = Utc::now();",
            entries[1])
        assert.equals(
            'tests/rust/src/main.rs:12:12:            chrono::NaiveDate::parse_from_str(&self.born, "%d-%m-%Y")',
            entries[2])
        assert.equals(
            "tests/rust/src/main.rs:19:8:        return today.signed_duration_since(borndate).num_days();",
            entries[3])

        assert.equals(
            "tests/rust/src/main.rs:31:4:    let age = p.calc_age_in_days();",
            entries[4])
        assert.equals(
            'tests/rust/src/main.rs:39:8:        name: "Donald Duck".to_string(),',
            entries[5])
        assert.equals(
            'tests/rust/src/main.rs:40:8:        born: "07-09-1934".to_string(),',
            entries[6])
        assert.equals(
            "tests/rust/src/main.rs:43:4:    donald.print(format_person);",
            entries[7])
    end)

    it("comments", function()
        local entries = lens._get_captures({
            queries = {"comments"},
            bufids = buffers
        })

        assert.equals(#entries, 2)
        assert.equals("tests/rust/src/main.rs:27:0:/*", entries[1])
        assert.equals("tests/rust/src/main.rs:37:4:    // Create Donald",
                      entries[2])
    end)
end)
