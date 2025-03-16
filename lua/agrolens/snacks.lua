local M = {}
local core = require("agrolens.core")

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
                local line = b.line:gsub("^%s+", "")
                local posnumber = tonumber(b.lnum)

                local text = b.filename .. ":" .. posnumber .. " " .. line

                table.insert(items, {
                    file = b.filename,
                    text = text,
                    line = line,
                    idx = idx,
                    pos = { posnumber, 0 },
                })
            end
            return items
        end
        local snacks = require("snacks")

        snacks.picker.pick({
            finder = get_choices,
            title = "Agrolens",
            layout = opts.snacks_layout,
        })
    end
end

return M
