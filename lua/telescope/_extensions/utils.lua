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

-- Borrowed from telescope.nvim
M.file_extension = function(filename)
    local parts = vim.split(filename, "%.")
    -- this check enables us to get multi-part extensions, like *.test.js for example
    if #parts > 2 then
        return table.concat(vim.list_slice(parts, #parts - 1), ".")
    else
        return table.concat(vim.list_slice(parts, #parts), ".")
    end

end

return M
