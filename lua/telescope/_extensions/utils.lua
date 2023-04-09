local M = {}

M.ltrim = function(s)
    return s:gsub("^%s*", "")
end

M.debug = function(msg)
    print(vim.inspect(msg))
end

M.all_trim = function(s)
    return s:match("^%s*(.-)%s*$")
end

return M
