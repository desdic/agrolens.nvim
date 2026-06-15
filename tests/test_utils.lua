local utils = require("agrolens.utils")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

T["ltrim"] = function()
    eq(utils.ltrim("  testing"), "testing")
    eq(utils.ltrim("  testing  "), "testing  ")
end

T["all_trim"] = function()
    eq(utils.all_trim("  testing"), "testing")
    eq(utils.all_trim("  testing  "), "testing")
end

T["file_extention"] = function()
    eq(utils.file_extension(vim.fs.basename("/home/myuser/test.go")), "go")
    eq(
        utils.file_extension(vim.fs.basename("/home/myuser/test.test.js")),
        "test.js"
    )
end

T["matchstr"] = function()
    eq(utils.matchstr("get the curr", [[\k*$]]), "curr")
    eq(utils.matchstr("ent word in a line ", [[\k*]]), "ent")
end

T["split"] = function()
    local elems = utils.split("test1=test2= test3", "=")
    eq(elems[1], "test1")
    eq(elems[2], "test2")
    eq(elems[3], " test3")
end

return T
