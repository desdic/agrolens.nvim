describe("c", function()
    local core = require("agrolens.core")
    local buffers = nil
    local eq = assert.equals

    it("load", function()
        vim.cmd.edit("tests/c/test.c")
        buffers = vim.api.nvim_list_bufs()
        eq(#buffers, 1)

        local content  = vim.api.nvim_buf_get_lines(buffers[1], 0, -1, false)

        -- make sure buffer has content
        eq(string.match(content[1], "include"), "include")

        core.get_captures({ queries = { "functions" }, bufids = buffers })
    end)

    it("functions", function()
        local entries =
            core.get_captures({ queries = { "functions" }, bufids = buffers })

        eq(#entries, 5)

        eq(entries[1].filename, "tests/c/test.c")
        eq(entries[1].lnum, 16)
        eq(entries[1].col, 0)
        eq(entries[1].line, "int days_since_birth(struct Person *p) {")
        eq(entries[2].line, "int basic_calc(struct Person *p) {")
        eq(
            entries[3].line,
            "void print_person(struct Person *p, format_func func) {"
        )
        eq(entries[4].line, "char **do_nothing(char **argv) {")
        eq(entries[5].line, "int main(int argc, char **argv) {")
    end)
    it("callings", function()
        local entries =
            core.get_captures({ queries = { "callings" }, bufids = buffers })
        eq(#entries, 10)

        eq(entries[1].filename, "tests/c/test.c")
        eq(entries[1].lnum, 23)
        eq(entries[1].col, 2)

        eq(
            entries[1].line,
            '  if (sscanf(p->born, "%d-%d-%d", &day, &month, &year) != EOF) {'
        )
        eq(entries[2].line, "    now = time(0);")
        eq(entries[3].line, "    parsedDate = localtime(&now);")
        eq(entries[4].line, "    time_t born = mktime(parsedDate);")
        eq(entries[5].line, "  return days_since_birth(p);")
        eq(entries[6].line, "  int age = (*func)(p);")
        eq(
            entries[7].line,
            '  printf("%s is %d days old\\n", p->name, (*func)(p));'
        )
        eq(entries[8].line, '  strncpy(donald.name, "Donald Duck", MAXNAME);')
        eq(entries[9].line, '  strncpy(donald.born, "07-09-1934", MAXDATE);')
        eq(entries[10].line, "  print_person(&donald, basic_calc);")
    end)
    it("comments", function()
        local entries =
            core.get_captures({ queries = { "comments" }, bufids = buffers })
        eq(#entries, 4)

        eq(entries[1].filename, "tests/c/test.c")
        eq(entries[1].lnum, 52)
        eq(entries[1].col, 0)

        eq(entries[1].line, "/*")
        eq(entries[2].line, "  // not used")
        eq(entries[3].line, "  // Create Donald")
        eq(entries[4].line, "  // Print Donald")
    end)
end)
