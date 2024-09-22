---
--- Agrolens is an extention for telescope that runs pre-defined (or custom)
--- tree-sitter queries on a buffer (or all buffers) and gives a quick
--- view via telescope.
---
---@usage Using Lazy plugin manager
---
--- {
---     "desdic/agrolens.nvim",
---     event = "VeryLazy",
---     keys = {
---         {
---             "ag",
---             function()
---                 require("agrolens").generate({})
---             end,
---         },
---     },
--- },
---
--- Enabling telescope extension (and default options)
--- Options can be overwritten when calling the extension
--- See |agrolens.telescope_opts| for options
--- >
--- require("telescope").extensions = {
---     agrolens = {
---        same_type = true,
---     }
--- }
---
--- Agrolens also has the ability to generate a tree-sitter query from
--- a given cursor postion.
---@tag agrolens.nvim

-- Module definition ==========================================================
local agrolens = {}

--- Default options when generation a query:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
agrolens.opts = {
    -- Register to copy to
    register = "",

    -- Create a buffer with query
    in_buffer = true,

    -- Copy query to register
    in_register = true,

    -- Generate query for full document/tree
    full_document = false,

    -- Generate all captures
    -- WARNING if the tree is big
    -- it can crash neovims playground
    all_captures = false,

    -- Include root node
    include_root_node = false,
}
--minidoc_afterlines_end

local ts_utils = require("nvim-treesitter.ts_utils")
local agroutils = require("telescope._extensions.utils")
local empty = vim.tbl_isempty
local len = vim.tbl_count

local get_field_name = function(node)
    local parent = node:parent()
    if parent then
        for child, field_name in parent:iter_children() do
            if child == node then
                return field_name
            end
        end
    end
    return nil
end

local get_parent_nodes_at_cursor = function()
    local node = ts_utils.get_node_at_cursor()

    if not node then
        return nil
    end

    local root = ts_utils.get_root_for_node(node)

    local nodes = {}
    while node ~= nil and node ~= root do
        table.insert(nodes, 1, node)
        node = node:parent()
    end

    return nodes
end

-- TODO maybe there is a better way to compare two nodes?
local is_same = function(node1, node2)
    if node1 and node2 then
        if node1:id() == node2:id() and node1:type() == node2:type() then
            return true
        end
    end

    return false
end

agrolens.create_entry = function(node, level)
    local node_type = node:type()
    local node_text = vim.treesitter.get_node_text(node, 0)
    local field_name = get_field_name(node)

    local entry = {
        node_type = node_type,
        node_text = node_text,
        field_name = field_name,
        node = node,
        level = level,
    }
    return entry
end

agrolens.traverse = function(results, node, cur_node, level)
    if is_same(node, cur_node) then
        local entry = agrolens.create_entry(node, level)

        table.insert(results, entry)

        return true
    end

    if node ~= nil then
        if node:named() then
            local entry = agrolens.create_entry(node, level)
            table.insert(results, entry)

            for next_node, _ in node:iter_children() do
                local done =
                    agrolens.traverse(results, next_node, cur_node, level + 1)
                if done then
                    return true
                end
            end
        end
    end
end

local function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

agrolens.do_closures = function(
    opts,
    block,
    next_node,
    numnodes,
    content,
    captures,
    count,
    captureid
)
    local level = block.level
    local next_level = numnodes
    if next_node then
        next_level = next_node.level
    end

    if level > next_level then
        local num = (level - next_level) + 1

        for x = 1, num do
            content = content .. ")"
            if captures[x] then
                if captures[x] == "@cap" then
                    content = content
                        .. " "
                        .. captures[x]
                        .. tostring(captureid)
                    captureid = captureid + 1
                else
                    content = content .. " " .. captures[x]
                end
            end
        end
        count = count - num
    elseif level == next_level then
        if opts.all_captures then
            if captures[level] and captures[level] ~= "@cap" then
                content = content .. ") " .. captures[level]
            else
                content = content .. ") @cap" .. tostring(captureid)
                captureid = captureid + 1
            end
        else
            content = content .. ")"
        end
        count = count - 1
    end

    return content, count, captureid
end

agrolens.end_closures = function(list, captures, count, captureid)
    if count > 0 then
        local index = len(list)
        for x = 1, count do
            list[index] = list[index] .. ")"
            if captures[x] then
                if captures[x] == "@cap" then
                    list[index] = list[index]
                        .. " "
                        .. captures[x]
                        .. tostring(captureid)
                    captureid = captureid + 1
                else
                    list[index] = list[index] .. " " .. captures[x]
                end
            end
        end
    end
end

agrolens.add_captures = function(opts, captures, capindex)
    if not captures[capindex] and opts.all_captures then
        captures[capindex] = "@cap"
    end
end

agrolens.match_line = function(block, line, captures, capindex)
    local pattern = "^%s*"
        .. escape_pattern(agroutils.ltrim(block.node_text))
        .. "$"
    local matches = string.match(line, pattern)

    if matches then
        captures[capindex] = "@agrolens.scope"
    end
end

agrolens.create_content = function(block, node_match, captures, capindex)
    if block.field_name then
        local content = string.rep(" ", block.level)
            .. block.field_name
            .. ":("
            .. block.node_type

        if is_same(block.node, node_match) then
            captures[capindex] = "@agrolens.name"
        end
        return content
    end

    return string.rep(" ", block.level) .. "(" .. block.node_type
end

--- Generate treesitter query
---
---@param opts table Options for generating query.
---
---@usage `require('agrolens').generate({})`
agrolens.generate = function(opts)
    local tree = {}

    opts = vim.tbl_deep_extend("force", agrolens.opts, opts or {})

    local line = vim.api.nvim_get_current_line()
    local cur_node = ts_utils.get_node_at_cursor()

    local root = ts_utils.get_root_for_node(cur_node)
    local parent = get_parent_nodes_at_cursor()
    local node_match = cur_node:parent()
    local from_node = root

    if not opts.full_document and parent then
        if type(parent) == "table" then
            from_node = parent[1]
        end
    end

    agrolens.traverse(tree, from_node, cur_node, 0)

    local list = {}
    local captures = {}
    local count = 0
    local numnodes = len(tree)
    local captureid = 1

    for i, block in ipairs(tree) do
        if block.node ~= root or opts.include_root_node then
            local capindex = numnodes - i
            local next_node = tree[i + 1]

            local content =
                agrolens.create_content(block, node_match, captures, capindex)
            count = count + 1

            agrolens.match_line(block, line, captures, capindex)
            agrolens.add_captures(opts, captures, capindex)

            content, count, captureid = agrolens.do_closures(
                opts,
                block,
                next_node,
                numnodes,
                content,
                captures,
                count,
                captureid
            )

            table.insert(list, content)
        end
    end

    agrolens.end_closures(list, captures, count, captureid)

    if not empty(list) then
        if opts.in_register then
            vim.fn.setreg(opts.register, list, "l")
        end

        if opts.in_buffer then
            local bufnr = vim.api.nvim_create_buf(true, true)
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, list)
            vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
        end
    end
end

return agrolens
