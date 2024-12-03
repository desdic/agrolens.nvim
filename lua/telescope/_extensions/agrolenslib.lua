local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local utils = require("agrolens.utils")
local core = require("agrolens.core")
local entry_display = require("telescope.pickers.entry_display")

local agrolens = {}

agrolens.telescope_opts = require("agrolens.config").opts

agrolens.entry_maker = function(entry)
    local basename = vim.fs.basename(entry.filename)

    local icon = ""
    local icon_width = 0
    local hl_group

    if agrolens.telescope_config.disable_devicons ~= true then
        icon, hl_group = agrolens.devicons.get_icon(
            basename,
            utils.file_extension(basename),
            { default = false }
        )
        icon_width = 2
    end

    local fname = entry.relfilename
    if
        agrolens.cur_opts.buffers ~= "all"
        and agrolens.telescope_opts.force_long_filepath ~= true
    then
        fname = vim.fs.basename(entry.filename)
    end

    local line = fname
        .. ":"
        .. entry.lnum
        .. ":"
        .. entry.col
        .. ":"
        .. entry.line

    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = icon_width },
            { width = agrolens.telescope_opts.display_width },
        },
    })

    local display = {}
    if hl_group then
        display = { icon, hl_group }
    end

    local make_display = function()
        return displayer({
            display,
            line,
        })
    end
    return {
        value = entry,
        ordinal = line,
        display = make_display,
        lnum = entry.lnum,
        col = entry.col,
        filename = entry.filename,
    }
end

agrolens.generate_new_finder = function(opts)
    local results = core.get_captures(opts)

    agrolens.log.debug("captured", results)

    return finders.new_table({
        results = results,
        entry_maker = opts.entry_maker,
    })
end

agrolens.run = function(opts)
    opts = opts or {}

    agrolens.cur_opts = opts

    agrolens.log.debug("Run with options:", opts)

    opts = core.sanitize_opts(
        opts,
        agrolens.telescope_opts,
        agrolens.telescope_config
    )

    if opts.query then
        opts.entry_maker = opts.entry_maker or agrolens.entry_maker
        opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()
        opts.previewer = opts.previewer or conf.grep_previewer(opts)
        opts.sorter = opts.sorter or conf.generic_sorter(opts)
        opts = core.get_buffers(opts)

        if opts.jump then
            local jumplist = core.generate_jump_list(opts)
            local curline = vim.api.nvim_win_get_cursor(0)[1]

            if opts.jump == "next" then
                core.jump_next(curline, jumplist)
            elseif opts.jump == "prev" then
                core.jump_prev(curline, jumplist)
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
