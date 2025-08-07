local fzf = {}

local contents = {}

local builtin = require("fzf-lua.previewer.builtin")
local fzfpreview = builtin.buffer_or_file:extend()

function fzfpreview:new(o, opts, fzf_win)
    fzfpreview.super.new(self, o, opts, fzf_win)
    setmetatable(self, fzfpreview)
    return self
end

function fzfpreview.parse_entry(_, entry_str)
    if entry_str == "" then
        return {}
    end

    local entry = contents[entry_str]
    return {
        path = entry.filename,
        line = entry.lnum or 1,
        col = 1,
    }
end

fzf.run = function(args)
    local opts = {}
    local cfg = require("agrolens.config").opts
    local core = require("agrolens.core")

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
        require("fzf-lua").fzf_exec(function(fzf_cb)
            local results = core.get_captures(opts)
            for _, b in ipairs(results) do
                local fname = b.relfilename

                if opts.force_long_filepath ~= true then
                    fname = vim.fs.basename(b.filename)
                end

                local key = fname .. ":" .. b.lnum .. ":" .. b.line
                contents[key] = b
                fzf_cb(key)
            end
            fzf_cb()
        end, {
            previewer = fzfpreview,
            prompt = "Agrolens> ",
            actions = {
                ["enter"] = {
                    fn = function(selected)
                        local entry = contents[selected[1]]

                        core.jump_to_buffer_line(
                            entry.bufnr,
                            entry.lnum,
                            entry.col
                        )
                    end,
                    silent = true,
                },
            },
        })
    end
end

return fzf
