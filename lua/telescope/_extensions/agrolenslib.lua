local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local queries = require("nvim-treesitter.query")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")

local function trim_string(s) return s:match("^%s*(.-)%s*$") end

M._create_entry = function(filename, matches, iter_query, bufnr, capture_name)
    local entry = {}
    entry.filename = filename
    entry.bufnr = bufnr

    for i, _ in pairs(matches) do
        local curr_capture_name = iter_query.captures[i]
        local row, from, torow, to = matches[i]:range()
        local line_text = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

        M.log.debug("got", line_text, to, torow)

        -- if multiline and its the capture line just include the line
        if to ~= torow and curr_capture_name == "rcapture" then
            from = 0
            to = -1
        end

        if not entry[curr_capture_name] then entry[curr_capture_name] = {} end

        entry[curr_capture_name].rawline = trim_string(line_text)
        entry[curr_capture_name].match = string.sub(line_text, from+1, to)
        entry[curr_capture_name].capture = capture_name

        entry.row = row + 1
        entry.line = line_text
    end
    return entry
end

M._add_entries = function(entries, capture_names, bufnr, filename, filetype)
    local ts = vim.treesitter
    local ok, tsparser = pcall(ts.get_parser, bufnr, filetype)
    if ok and tsparser and type(tsparser) ~= "string" then
        local trees = tsparser:parse()
        local root = trees[1]:root()

        for _, capture_name in ipairs(capture_names) do
            local okgetq, iter_query = pcall(queries.get_query, filetype, capture_name)
            if okgetq and iter_query then
                for _, matches, _ in iter_query:iter_matches(root, bufnr) do
                    local entry = M._create_entry(filename, matches, iter_query, bufnr, capture_name)
                    table.insert(entries, entry)
                end
            end
        end
    end
    return entries
end

M._get_captures = function(opts)
    local entries = {}

    for _, bufnr in ipairs(opts.buffers) do
        if vim.fn.getbufinfo(bufnr)[1].hidden == 0 then
            local buffilename = vim.api.nvim_buf_get_name(bufnr)
            local filetype = vim.filetype.match({buf = bufnr})

            if filetype and filetype ~= "" then
                entries = M._add_entries(entries, opts.commands, bufnr, buffilename, filetype)
            end
        end
    end
    return entries
end

M._generate_new_finder = function(opts)
    return finders.new_table({
        results = M._get_captures(opts),
        entry_maker = function(entry)
            local displayer = entry_display.create({
                separator = ":",
                items = {{width = 80}, {remaining = false}, {remaining = true}}
            })
            local make_display = function()
                return displayer({
                    trim_string(entry.rcapture.rawline), vim.fs.basename(entry.filename), tostring(entry.row),
                    entry.rcapture.capture_name
                })
            end
            local ordinal = entry.rcapture.rawline .. ":" .. entry.filename
            return {
                value = entry,
                ordinal = ordinal,
                display = make_display,
                lnum = entry.row,
                col = entry.col,
                bufnr = entry.bufnr,
                filename = entry.filename
            }
        end
    })
end

M._make_bufferlist = function(opts)
    local buffers = {}

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if opts.includehiddenbuffers == false then
            if vim.fn.getbufinfo(bufnr)[1].listed == 1 then
                table.insert(buffers, bufnr)
            end
        else
            table.insert(buffers, bufnr)
        end
    end
    return buffers
end

M._param_to_opts = function(args, opts)

    local commands = {}
    if args.commands then
        for command in args.commands:gmatch('[^,%s]+') do
            table.insert(commands, command)
        end
    end
    opts.commands = commands
    M.log.debug("commands", commands)

    local includehiddenbuffers = false
    if args.includehiddenbuffers and args.includehiddenbuffers==true then
        includehiddenbuffers = true
    end
    opts.includehiddenbuffers = includehiddenbuffers
    M.log.debug("includehiddenbuffers", includehiddenbuffers)

    local curbuf = vim.api.nvim_get_current_buf()

    local buffers = {curbuf}
    if args.buffers and type(args.buffers) == "string" then
        if args.buffers == "all" then
            buffers[curbuf] = nil
            buffers = M._make_bufferlist(opts)
        end
    end
    opts.buffers = buffers
    M.log.debug("buffers", buffers)

    return opts
end

M.setup = function(log)
    M.log = log
end

M.run = function(args)
    local opts = {}

    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    opts = M._param_to_opts(args, opts)

    pickers.new(opts, {
        prompt_title = "Search",
        finder = M._generate_new_finder(opts),
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts)
    }):find()
end

return M
