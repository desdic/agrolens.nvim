local M = {}

local len = vim.tbl_count

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

M.matchstr = function(...)
    local ok, ret = pcall(vim.fn.matchstr, ...)
    return ok and ret or ""
end

M.split = function(source, delimiters)
    local elements = {}
    local pattern = "([^" .. delimiters .. "]+)"
    --- Keep linter happy
    local _ = string.gsub(source, pattern, function(value)
        elements[len(elements) + 1] = value
    end)
    return elements
end

M.get_word_at_cursor = function()
    local column = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()

    local left = M.matchstr(line:sub(1, column + 1), [[\k*$]])
    local right = M.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

    return left .. right
end

M.format_entry = function(entry)
    return string.format(
        "%s:%d:%d:%s",
        entry.filename,
        entry.lnum,
        entry.col,
        entry.line
    )
end

M.hash_keys_to_list = function(entries)
    local list = {}
    for k, _ in pairs(entries) do
        table.insert(list, k)
    end
    return list
end

M.make_bufferlist = function(opts)
    local buffers = {}

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if
            opts.same_type == false
            or vim.filetype.match({ buf = bufnr }) == opts.cur_type
        then
            if opts.include_hidden_buffers == false then
                if vim.fn.getbufinfo(bufnr)[1].listed == 1 then
                    table.insert(buffers, bufnr)
                end
            else
                table.insert(buffers, bufnr)
            end
        end
    end
    return buffers
end

M.get_buffers = function(opts)
    local curbuf = vim.api.nvim_get_current_buf()

    opts.cur_type = vim.filetype.match({ buf = curbuf })

    local bufids = { curbuf }
    if opts.buffers and type(opts.buffers) == "string" then
        if opts.buffers == "all" then
            bufids[curbuf] = nil
            bufids = M.make_bufferlist(opts)
        end
    end
    opts.bufids = bufids

    return opts
end

return M
