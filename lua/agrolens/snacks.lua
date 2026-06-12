local M = {}

M.run = function(args)
    local core = require("agrolens.core")
    local opts = core.prepare(args)
    if not opts then
        return
    end

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

return M
