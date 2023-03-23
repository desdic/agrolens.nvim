describe("python", function()

    local lens = nil
    local buffers = nil

    it("load", function()
        vim.cmd.edit("tests/python/test.py")
        buffers = vim.api.nvim_list_bufs()
        assert.equal(#buffers, 1)

        lens = require("telescope._extensions.agrolenslib")
        lens._get_captures({queries={"functions"}, bufids=buffers})
    end)

    it("functions", function()
        local entries = lens._get_captures({queries={"functions"}, bufids=buffers})

        assert.equals(#entries, 3)
        assert.equals("tests/python/test.py:10:4:    def hello(self):", entries[1])
        assert.equals("tests/python/test.py:14:0:def hello():", entries[2])
        assert.equals("tests/python/test.py:18:0:def main():", entries[3])
    end)

    it("callings", function()
        local entries = lens._get_captures({queries={"callings"}, bufids=buffers})

        assert.equals(#entries, 11)
        assert.equals("tests/python/test.py:6:9:logger = logging.getLogger(__name__)", entries[1])
        assert.equals('tests/python/test.py:11:8:        print("hello")', entries[2])
        assert.equals("tests/python/test.py:19:21:    arg_parser = argparse.ArgumentParser()", entries[3])
        assert.equals('tests/python/test.py:20:8:    arg_parser.add_argument("--debug", "-d", action="store_true", help="enable debug")', entries[4])
        assert.equals("tests/python/test.py:21:15:    args = arg_parser.parse_args()", entries[5])
        assert.equals("tests/python/test.py:23:8:    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)", entries[6])
        assert.equals('tests/python/test.py:25:4:    msg = hello()', entries[7])
        assert.equals('tests/python/test.py:26:4:    print(msg)', entries[8])
        assert.equals('tests/python/test.py:27:4:    m = Stuff()', entries[9])
        assert.equals('tests/python/test.py:28:8:    m.hello()', entries[10])
        assert.equals('tests/python/test.py:32:4:    main()', entries[11])
    end)
end)
