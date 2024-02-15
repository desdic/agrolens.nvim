local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local ppath = require("plenary.path")
local plenary = require("plenary")
local utils = require("telescope._extensions.utils")

local agrolens =
    { log = plenary.log.new({ plugin = "agrolens", level = "info" }) }

--- Default telescope options:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
agrolens.telescope_opts = {
    -- Enable/Disable debug messages
    debug = false,

    -- Some tree-sitter plugins uses hidden buffers
    -- and we can enable those to if we want
    include_hidden_buffers = false,

    -- Make sure the query only runs on
    -- same filetype as the current one
    same_type = true,

    -- Match a given string or object
    -- Example `:Telescope agrolens query=callings buffers=all same_type=false match=name,object`
    -- this will query all callings but only those who match the word on the cursor
    match = nil,

    -- Disable displaying indententations in telescope
    disable_indentation = false,

    -- Alias can be used to join several queries into a single name
    -- Example: `aliases = { yamllist = "docker-compose,github-workflow-steps"}`
    aliases = {},

    -- Several internal functions can also be overwritten
    --
    -- Default entry make is the one used for grep
    -- entry_maker = make_entry.gen_from_vimgrep(opts)
    --
    -- Default way of finding current directory
    -- cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
    --
    -- Default previewer
    -- previewer = conf.grep_previewer(opts)
    --
    -- Default sorting
    -- sorter = conf.generic_sorter(opts)
}
--minidoc_afterlines_end

agrolens._create_entry = function(
    filename,
    matches,
    iter_query,
    bufnr,
    capture_name
)
    local entry = {}
    entry.filename = filename
    entry.bufnr = bufnr

    for i, _ in pairs(matches) do
        local curr_capture_name = iter_query.captures[i]
        local lnum, from, torow, to = matches[i]:range()
        local line_text =
            vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]

        agrolens.log.debug("got", line_text, to, torow)

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

agrolens._add_entries = function(
    opts,
    entries,
    capture_names,
    bufnr,
    filename,
    filetype
)
    local ts = vim.treesitter
    if opts.buffers ~= "all" then
        filename = vim.fs.basename(filename)
    end
    local dublicates = {}
    local ok, tsparser = pcall(ts.get_parser, bufnr, filetype)
    if ok and tsparser and type(tsparser) ~= "string" then
        local trees = tsparser:parse()
        local root = trees[1]:root()

        for _, capture_name in ipairs(capture_names) do
            local iter_query =
                vim.treesitter.query.get(filetype, "agrolens." .. capture_name)
            if iter_query then
                for _, matches, _ in iter_query:iter_matches(root, bufnr) do
                    local entry = agrolens._create_entry(
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

agrolens.jump_next = function(curline, jumplist)
    table.sort(jumplist)
    for _, line in pairs(jumplist) do
        if line > curline then
            vim.api.nvim_win_set_cursor(0, { line, 0 })
            break
        end
    end
end

agrolens.jump_prev = function(curline, jumplist)
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

local hash_keys_to_list = function(entries)
    local list = {}
    for k, _ in pairs(entries) do
        table.insert(list, k)
    end
    return list
end

agrolens._generate_jump_list = function(opts)
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

    return hash_keys_to_list(entries)
end

agrolens._get_captures = function(opts)
    local entries = {}

    for _, bufnr in ipairs(opts.bufids) do
        local buffilename = vim.api.nvim_buf_get_name(bufnr)
        local relpath = ppath:new(buffilename):make_relative(opts.cwd)
        local filetype = vim.filetype.match({ buf = bufnr })

        if filetype and filetype ~= "" then
            entries = agrolens._add_entries(
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

agrolens._make_bufferlist = function(opts)
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
        elements[vim.tbl_count(elements) + 1] = value
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

agrolens._sanitize_opts = function(opts)
    opts.queries = {}

    opts = vim.tbl_deep_extend(
        "force",
        agrolens.telescope_opts,
        opts or {},
        agrolens.telescope_config
    )

    opts.query = opts.aliases[opts.query] or opts.query

    if opts.query then
        for query in opts.query:gmatch("[^,%s]+") do
            table.insert(opts.queries, query)
        end
    end

    local matches = {}
    if opts.match then
        local current_work = get_word_at_cursor()

        for match in opts.match:gmatch("[^,%s]+") do
            local elements = split(match, "=")

            if vim.tbl_count(elements) == 1 then
                table.insert(elements, current_work)
            end

            local entry = {}
            entry.name = elements[1]
            entry.word = elements[2]

            table.insert(matches, entry)
        end
    end

    opts.disable_indentation = agrolens.telescope_config.disable_indentation
        or false

    if not vim.tbl_isempty(matches) then
        opts.matches = matches
    end

    return opts
end

agrolens._get_buffers = function(opts)
    local curbuf = vim.api.nvim_get_current_buf()

    opts.cur_type = vim.filetype.match({ buf = curbuf })

    local bufids = { curbuf }
    if opts.buffers and type(opts.buffers) == "string" then
        if opts.buffers == "all" then
            bufids[curbuf] = nil
            bufids = agrolens._make_bufferlist(opts)
        end
    end
    opts.bufids = bufids

    return opts
end

agrolens.generate_new_finder = function(opts)
    return finders.new_table({
        results = agrolens._get_captures(opts),
        entry_maker = opts.entry_maker,
    })
end

agrolens.run = function(opts)
    opts = opts or {}

    opts = agrolens._sanitize_opts(opts)

    if not agrolens.log then
        agrolens.log = plenary.log.new({ plugin = "agrolens", level = "info" })
    end

    if opts.query then
        opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
        opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
        opts.previewer = opts.previewer or conf.grep_previewer(opts)
        opts.sorter = opts.sorter or conf.generic_sorter(opts)
        opts = agrolens._get_buffers(opts)

        if opts.jump then
            local jumplist = agrolens._generate_jump_list(opts)
            local curline = vim.api.nvim_win_get_cursor(0)[1]

            if opts.jump == "next" then
                agrolens.jump_next(curline, jumplist)
            elseif opts.jump == "prev" then
                agrolens.jump_prev(curline, jumplist)
            end
        else
            pickers
                .new(opts, {
                    prompt_title = "Search",
                    finder = agrolens.generate_new_finder(opts),
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
end

return agrolens
