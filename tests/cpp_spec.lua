describe("cpp", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/cpp/main.cc")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "include"), "include")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries =
            core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 4)
        eq(entries[1].relfilename, "tests/cpp/main.cc")
        eq(entries[1].lnum, 18)
        eq(entries[1].col, 0)

        eq(
            entries[1].line,
            "Person::Person(std::string name, std::string born) {"
        )
        eq(entries[2].line, "int sec_to_days(time_t now, time_t born) { ")
        eq(
            entries[3].line,
            "int days_since_birth(const Person &p, conv_func func) {"
        )
        eq(entries[4].line, "int main() {")
    end)

    it("callings", function()
        local entries =
            core.get_captures({ queries = { "callings" }, bufids = buffers })

        eq(#entries, 5)
        eq(entries[1].relfilename, "tests/cpp/main.cc")
        eq(entries[1].lnum, 36)
        eq(entries[1].col, 4)

        eq(entries[1].line, '    time_t now = time(0);')
        eq(entries[2].line, '    parsedDate = localtime(&now);')
        eq(entries[3].line, '    time_t born = mktime(parsedDate);')
        eq(entries[4].line, '    int age = (*func)(now, born);')
        eq(entries[5].line, '  out << p.name << " is " << days_since_birth(p, sec_to_days) << " days old";')
    end)

    it("comments", function()
        local entries =
            core.get_captures({ queries = { "comments" }, bufids = buffers })

        eq(#entries, 3)
        eq(entries[1].relfilename, "tests/cpp/main.cc")
        eq(entries[1].lnum, 23)
        eq(entries[1].col, 0)
        eq(entries[1].line, '/* basic seconds to days')
        eq(entries[2].line, '  // Create Donald')
        eq(entries[3].line, '  // Print Donald')
    end)
end)
