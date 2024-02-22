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

M.file_extension = function(filename)
    local parts = vim.split(filename, "%.")
    if #parts > 2 then
      return table.concat(vim.list_slice(parts, #parts - 1), ".")
    end
    return nil
end

return M
