local M = {}
local core = require("agrolens.core")
local utils = require("agrolens.utils")

M.run = function(args)
    local opts = {}
    local cfg = require("agrolens.config").opts

    opts = core.sanitize_opts(opts, cfg, args)

    opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()
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
        local function get_choices()
            local items = {}

            local results = core.get_captures(opts)
            for idx, b in ipairs(results) do
                local fname = b.relfilename

                if opts.force_long_filepath ~= true then
                    fname = vim.fs.basename(b.filename)
                end

                table.insert(items, {
                    file = b.filename,
                    line = b.line:gsub("^%s+", ""),
                    idx = idx,
                    pos = { tonumber(b.lnum), 0 },
                })
            end
            return items
        end
        local snacks = require("snacks")

        snacks.picker.pick({
            finder = get_choices,
            title = "Agrolens",
            layout = { preview = true },
        })
    end
end

return M
