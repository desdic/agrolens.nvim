describe("c", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/c/test.c")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 4)

        assert.equals('tests/c/test.c:16:0:int days_since_birth(struct Person *p) {', entries[1])
        assert.equals('tests/c/test.c:45:0:int basic_calc(struct Person *p) {', entries[2])
        assert.equals('tests/c/test.c:55:0:void print_person(struct Person *p, format_func func) {', entries[3])
        assert.equals('tests/c/test.c:62:0:int main() {', entries[4])
    end)
    it("callings", function()
        local entries = lens._get_captures({queries={"callings"}, bufids=buffers})
        assert.equals(#entries, 9)

        assert.equals('tests/c/test.c:23:2:  if (sscanf(p->born, "%d-%d-%d", &day, &month, &year) != EOF) {', entries[1])
        assert.equals('tests/c/test.c:25:4:    now = time(0);', entries[2])
        assert.equals('tests/c/test.c:29:4:    parsedDate = localtime(&now);', entries[3])
        assert.equals('tests/c/test.c:34:4:    time_t born = mktime(parsedDate);', entries[4])
        assert.equals('tests/c/test.c:49:2:  return days_since_birth(p);', entries[5])
        assert.equals('tests/c/test.c:59:2:  printf("%s is %d days old\\n", p->name, (*func)(p));', entries[6])
        assert.equals('tests/c/test.c:66:2:  strncpy(donald.name, "Donald Duck", MAXNAME);', entries[7])
        assert.equals('tests/c/test.c:67:2:  strncpy(donald.born, "07-09-1934", MAXDATE);', entries[8])
        assert.equals('tests/c/test.c:70:2:  print_person(&donald, basic_calc);', entries[9])
    end)
    it("comments", function()
        local entries = lens._get_captures({queries={"comments"}, bufids=buffers})
        assert.equals(#entries, 3)

        assert.equals('tests/c/test.c:52:0:/*', entries[1])
        assert.equals('tests/c/test.c:64:2:  // Create Donald', entries[2])
        assert.equals('tests/c/test.c:69:2:  // Print Donald', entries[3])
    end)

end)
