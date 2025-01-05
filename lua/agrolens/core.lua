local M = {}

local utils = require("agrolens.utils")
local ppath = require("plenary.path")
local empty = vim.tbl_isempty
local len = vim.tbl_count

M.create_entry = function(
    filename,
    relfilename,
    matches,
    iter_query,
    bufnr,
    capture_name
)
    local entry = {}
    entry.filename = filename
    entry.relfilename = relfilename
    entry.bufnr = bufnr

    for i, _ in pairs(matches) do
        local curr_capture_name = iter_query.captures[i]
        local lnum, from, torow, to = matches[i]:range()
        local line_text =
            vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]

        -- if multiline and its the capture line just include the line
        if to ~= torow and curr_capture_name == "agrolens.scope" then
            from = 0
            to = -1
        end

        if not entry[curr_capture_name] then
            entry[curr_capture_name] = {}
        end

        entry[curr_capture_name].match = string.sub(line_text, from + 1, to)
        entry[curr_capture_name].capture = capture_name

        entry.lnum = lnum + 1
        entry.col = from
            + (string.len(line_text) - string.len(utils.ltrim(line_text)))
        entry.line = line_text
    end
    return entry
end

M.does_match = function(opts, entry)
    -- no matches defined
    if not opts.matches then
        return true
    end

    for _, match in ipairs(opts.matches) do
        local n = "agrolens." .. match.name
        if entry[n] then
            -- only one has to match (or and not and)
            if match.word == entry[n].match then
                return true
            end
        end
    end

    return false
end

M.add_entries = function(
    opts,
    entries,
    capture_names,
    bufnr,
    filename,
    relfilename,
    filetype
)
    local ts = vim.treesitter
    local dublicates = {}
    local ok, tsparser = pcall(ts.get_parser, bufnr, filetype)
    if ok and tsparser and type(tsparser) ~= "string" then
        local trees = tsparser:parse()
        local root = trees[1]:root()

        for _, capture_name in ipairs(capture_names) do
            local iter_query =
                vim.treesitter.query.get(filetype, "agrolens." .. capture_name)
            if iter_query then
                for _, matches, _ in
                    iter_query:iter_matches(root, bufnr, 0, -1, { all = false })
                do
                    if matches ~= nil then
                        local entry = M.create_entry(
                            filename,
                            relfilename,
                            matches,
                            iter_query,
                            bufnr,
                            capture_name
                        )

                        if opts.disable_indentation then
                            entry.line = utils.all_trim(entry.line)
                        end

                        local formated_entry = utils.format_entry(entry)
                        if not dublicates[formated_entry] then
                            dublicates[formated_entry] = true
                            if M.does_match(opts, entry) then
                                table.insert(entries, entry)
                            end
                        end
                    end
                end
            end
        end
    end
    return entries
end

M.get_captures = function(opts)
    local entries = {}

    for _, bufnr in ipairs(opts.bufids) do
        local buffilename = vim.api.nvim_buf_get_name(bufnr)
        local relfilename = ppath:new(buffilename):make_relative(opts.cwd)
        local filetype = vim.filetype.match({ buf = bufnr })

        if filetype and filetype ~= "" then
            entries = M.add_entries(
                opts,
                entries,
                opts.queries,
                bufnr,
                buffilename,
                relfilename,
                filetype
            )
        end
    end
    return entries
end

M.generate_jump_list = function(opts)
    local entries = {}
    local ts = vim.treesitter
    local capture_names = opts.queries
    local bufnr = 0
    local filetype = vim.filetype.match({ buf = bufnr })
    if filetype and filetype ~= "" then
        local ok, tsparser = pcall(ts.get_parser, bufnr, filetype)
        if ok and tsparser and type(tsparser) ~= "string" then
            local trees = tsparser:parse()
            local root = trees[1]:root()

            for _, capture_name in ipairs(capture_names) do
                local iter_query = vim.treesitter.query.get(
                    filetype,
                    "agrolens." .. capture_name
                )
                if iter_query then
                    for _, matches, _ in iter_query:iter_matches(root, bufnr) do
                        for i, _ in pairs(matches) do
                            local curr_capture_name = iter_query.captures[i]
                            local lnum, _, _, _ = matches[i]:range()
                            if curr_capture_name == "agrolens.scope" then
                                entries[lnum + 1] = true
                            end
                        end
                    end
                end
            end
        end
    end

    return utils.hash_keys_to_list(entries)
end

M.sanitize_opts = function(opts, telescope_opts, telescope_config)
    opts.queries = {}

    opts = vim.tbl_deep_extend(
        "force",
        telescope_opts,
        opts or {},
        telescope_config
    )

    opts.query = opts.aliases[opts.query] or opts.query

    if opts.query then
        for query in opts.query:gmatch("[^,%s]+") do
            table.insert(opts.queries, query)
        end
    end

    local matches = {}
    if opts.match then
        local current_word = utils.get_word_at_cursor()

        for match in opts.match:gmatch("[^,%s]+") do
            local elements = utils.split(match, "=")

            if len(elements) == 1 then
                table.insert(elements, current_word)
            end

            local entry = {}
            entry.name = elements[1]
            entry.word = elements[2]

            table.insert(matches, entry)
        end
    end

    opts.disable_indentation = telescope_config.disable_indentation or false

    if not empty(matches) then
        opts.matches = matches
    end

    return opts
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

M.jump_to_buffer_line = function(bufnr, row, col)
    vim.api.nvim_set_current_buf(bufnr)

    pcall(function()
        vim.api.nvim_win_set_cursor(0, {
            row or 1,
            col or 0,
        })
    end)
end

M.jump_next = function(curline, jumplist)
    table.sort(jumplist)
    for _, line in pairs(jumplist) do
        if line > curline then
            vim.api.nvim_win_set_cursor(0, { line, 0 })
            break
        end
    end
end

M.jump_prev = function(curline, jumplist)
    table.sort(jumplist, function(a, b)
        return a > b
    end)
    for _, line in pairs(jumplist) do
        if line < curline then
            vim.api.nvim_win_set_cursor(0, { line, 0 })
            break
        end
    end
end
return M
