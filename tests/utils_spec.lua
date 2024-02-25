describe("utils", function()
    local utils = require("telescope._extensions.utils")

    local eq = assert.equals

    it("ltrim", function()
        eq(utils.ltrim("  testing"), "testing")
        eq(utils.ltrim("  testing  "), "testing  ")
    end)

    it("all_trim", function()
        eq(utils.all_trim("  testing"), "testing")
        eq(utils.all_trim("  testing  "), "testing")
    end)

    it("file_extention", function()
        eq(utils.file_extension(vim.fs.basename("/home/myuser/test.go")), "go")
        eq(utils.file_extension(vim.fs.basename("/home/myuser/test.test.js")), "test.js")
    end)

    it("matchstr", function()
        eq(utils.matchstr("get the curr", [[\k*$]]), "curr")
        eq(utils.matchstr("ent word in a line ", [[\k*]]), "ent")
    end)

    it("split", function()
        local elems = utils.split("test1=test2= test3", "=")
        eq(elems[1], "test1")
        eq(elems[2], "test2")
        eq(elems[3], " test3")
    end)

end)
