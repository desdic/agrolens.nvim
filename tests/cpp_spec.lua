describe("cpp", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/cpp/main.cc")
        buffers = vim.api.nvim_list_bufs()

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 4)
        assert.equals('tests/cpp/main.cc:18:0:Person::Person(std::string name, std::string born) {', entries[1])
        assert.equals('tests/cpp/main.cc:25:0:int sec_to_days(time_t now, time_t born) { ', entries[2])
        assert.equals('tests/cpp/main.cc:28:0:int days_since_birth(const Person &p, conv_func func) {', entries[3])
        assert.equals('tests/cpp/main.cc:61:0:int main() {', entries[4])
    end)

    it("callings", function()
        local entries = lens._get_captures({queries={"callings"}, bufids=buffers})

        assert.equals(#entries, 5)
        assert.equals('tests/cpp/main.cc:36:4:    time_t now = time(0);', entries[1])
        assert.equals('tests/cpp/main.cc:39:4:    parsedDate = localtime(&now);', entries[2])
        assert.equals('tests/cpp/main.cc:44:4:    time_t born = mktime(parsedDate);', entries[3])
        assert.equals('tests/cpp/main.cc:46:4:    int age = (*func)(now, born);', entries[4])
        assert.equals('tests/cpp/main.cc:56:2:  out << p.name << " is " << days_since_birth(p, sec_to_days) << " days old";', entries[5])
    end)

    it("comments", function()
        local entries = lens._get_captures({queries={"comments"}, bufids=buffers})

        assert.equals(#entries, 3)
        assert.equals('tests/cpp/main.cc:23:0:/* basic seconds to days', entries[1])
        assert.equals('tests/cpp/main.cc:63:2:  // Create Donald', entries[2])
        assert.equals('tests/cpp/main.cc:66:2:  // Print Donald', entries[3])
    end)
end)
