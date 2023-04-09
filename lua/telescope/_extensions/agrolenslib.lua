local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local queries = require("nvim-treesitter.query")
local ppath = require("plenary.path")
local plenary = require("plenary")
local utils = require("telescope._extensions.utils")

local M = { log = plenary.log.new({ plugin = "agrolens", level = "info" }) }

---@brief [[
--- Its an extention for telescope that runs pre-defined (or custom) tree-sitter queries on a buffer (or all buffers) and gives a quick view via telescope
---@brief ]]

---@tag agrolens.nvim
---@config { ["name"] = "INTRODUCTION"}

M._create_entry = function(filename, matches, iter_query, bufnr, capture_name)
    local entry = {}
    entry.filename = filename
    entry.bufnr = bufnr

    for i, _ in pairs(matches) do
        local curr_capture_name = iter_query.captures[i]
        local lnum, from, torow, to = matches[i]:range()
        local line_text =
            vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]

        M.log.debug("got", line_text, to, torow)

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

local format_entry = function(entry)
    return string.format(
        "%s:%d:%d:%s",
        entry.filename,
        entry.lnum,
        entry.col,
        entry.line
    )
end

local does_match = function(opts, entry)
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

M._add_entries = function(
    opts,
    entries,
    capture_names,
    bufnr,
    filename,
    filetype
)
    local ts = vim.treesitter
    local dublicates = {}
    local ok, tsparser = pcall(ts.get_parser, bufnr, filetype)
    if ok and tsparser and type(tsparser) ~= "string" then
        local trees = tsparser:parse()
        local root = trees[1]:root()

        for _, capture_name in ipairs(capture_names) do
            local okgetq, iter_query =
                pcall(queries.get_query, filetype, "agrolens." .. capture_name)
            if okgetq and iter_query then
                for _, matches, _ in iter_query:iter_matches(root, bufnr) do
                    local entry = M._create_entry(
                        filename,
                        matches,
                        iter_query,
                        bufnr,
                        capture_name
                    )

                    if opts.disable_indentation then
                        entry.line = utils.all_trim(entry.line)
                    end
                    local formated_entry = format_entry(entry)

                    if not dublicates[formated_entry] then
                        dublicates[formated_entry] = true
                        if does_match(opts, entry) then
                            table.insert(entries, formated_entry)
                        end
                    end
                end
            end
        end
    end
    return entries
end

M._get_captures = function(opts)
    local entries = {}

    for _, bufnr in ipairs(opts.bufids) do
        local buffilename = vim.api.nvim_buf_get_name(bufnr)
        local relpath = ppath:new(buffilename):make_relative(opts.cwd)
        local filetype = vim.filetype.match({ buf = bufnr })

        if filetype and filetype ~= "" then
            entries = M._add_entries(
                opts,
                entries,
                opts.queries,
                bufnr,
                relpath,
                filetype
            )
        end
    end
    return entries
end

M._make_bufferlist = function(opts)
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

local function split(source, delimiters)
    local elements = {}
    local pattern = "([^" .. delimiters .. "]+)"
    --- Keep linter happy
    local _ = string.gsub(source, pattern, function(value)
        elements[#elements + 1] = value
    end)
    return elements
end

local function matchstr(...)
    local ok, ret = pcall(vim.fn.matchstr, ...)
    return ok and ret or ""
end

local function get_word_at_cursor()
    local column = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()

    local left = matchstr(line:sub(1, column + 1), [[\k*$]])
    local right = matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

    return left .. right
end

M._sanitize_opts = function(opts)
    local querylist = {}

    local aliases = M.telescope_config.aliases or {}
    opts.query = aliases[opts.query] or opts.query

    if opts.query then
        for query in opts.query:gmatch("[^,%s]+") do
            table.insert(querylist, query)
        end
    end
    opts.queries = querylist

    local include_hidden_buffers = M.telescope_config.include_hidden_buffers
        or false
    if opts.include_hidden_buffers == true then
        include_hidden_buffers = true
    end
    opts.include_hidden_buffers = include_hidden_buffers

    local same_type = M.telescope_config.same_type
    if opts.same_type == false then
        same_type = false
    end
    opts.same_type = same_type

    local matches = {}
    if opts.match then
        local current_work = get_word_at_cursor()

        for match in opts.match:gmatch("[^,%s]+") do
            local elements = split(match, "=")

            if #elements == 1 then
                table.insert(elements, current_work)
            end

            local entry = {}
            entry.name = elements[1]
            entry.word = elements[2]

            table.insert(matches, entry)
        end
    end

    opts.disable_indentation = M.telescope_config.disable_indentation or false

    if #matches > 0 then
        opts.matches = matches
    end

    return opts
end

M._get_buffers = function(opts)
    local curbuf = vim.api.nvim_get_current_buf()

    opts.cur_type = vim.filetype.match({ buf = curbuf })

    local bufids = { curbuf }
    if opts.buffers and type(opts.buffers) == "string" then
        if opts.buffers == "all" then
            bufids[curbuf] = nil
            bufids = M._make_bufferlist(opts)
        end
    end
    opts.bufids = bufids

    return opts
end

--- Generate a new finder for telescope
---@param opts table: options
---@field entry_maker function: function(line: string) => table (Optional)
---@field cwd string: current root directory (Optional)
---@field previewer function: function(line: string) => table (Optional)
---@field sorter function: function(line: string) => table (Optional)
---@field same_type bool: if buffers should be of same filetype (default false)
---@field include_hidden_buffers bool: if hidden buffers should be included (default false)
---@field disable_indentation bool: if true it strips the whitespaces (default false)
---@field debug bool: enable debugging (default false)
---@field matches table: key/value pair for matching variable names
---@field aliases table: key/value pair for aliases for longer lists of queries (value is comma seperated)
M.generate_new_finder = function(opts)
    return finders.new_table({
        results = M._get_captures(opts),
        entry_maker = opts.entry_maker,
    })
end

M.__check_deprecated = function(opts)
    if M.telescope_config.disableindentation or opts.disableindentation then
        M.log.warn("disableindentation deprecated use disable_indentation")
    end
    if M.telescope_config.sametype or opts.sametype then
        M.log.warn("sametype is deprecated use same_type")
    end
    if M.telescope_config.includehiddenbuffers or opts.includehiddenbuffers then
        M.log.warn(
            "includehiddenbuffers is deprecated use include_hidden_buffers"
        )
    end
end

M.run = function(opts)
    opts = opts or {}

    M.__check_deprecated(opts)
    opts = M._sanitize_opts(opts)

    if not M.log then
        M.log = plenary.log.new({ plugin = "agrolens", level = "info" })
    end

    if opts.query then
        opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
        opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
        opts.previewer = opts.previewer or conf.grep_previewer(opts)
        opts.sorter = opts.sorter or conf.generic_sorter(opts)
        opts = M._get_buffers(opts)

        pickers
            .new(opts, {
                prompt_title = "Search",
                finder = M.generate_new_finder(opts),
                previewer = opts.previewer,
                sorter = opts.sorter,
                attach_mappings = function(_, map)
                    map("i", "<c-space>", actions.to_fuzzy_refine)
                    return true
                end,
            })
            :find()
    end
end

return M
