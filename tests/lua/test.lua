local hello1 = function()
    print("hello1")
end

hello2 = function()
    print("hello2")
end

function hello3()
    print("hello3")
end

-- Local object
local M = {}

--[[
Ms hello function
--]]
M.hello4 = function()
    print("hello4")
end

function M.hello5()
    print("hello5")
end

function M:hello6()
    print("hello6")
end

hello1()
hello2()
hello3()
M.hello4()
M.hello5()
M:hello6()
