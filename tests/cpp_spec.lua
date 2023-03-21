describe("cpp", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/cpp/main.cc")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 4)
        assert.equals("tests/cpp/main.cc:7:2:  Person(int age) : age(age) {}", entries[1])
        assert.equals("tests/cpp/main.cc:8:2:  int getAge() { return age; }", entries[2])
        assert.equals("tests/cpp/main.cc:12:0:void Person::setAge(int age) { this->age = age; }", entries[3])
        assert.equals("tests/cpp/main.cc:14:0:int main() {", entries[4])

    end)
end)
