local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then error("agrolens.nvim requires nvim-telescope/telescope.nvim") end

local has_plenary, plenary = pcall(require, "plenary")
if not has_plenary then
    error("This extension requires plenary")
    return
end

local agrolens = require("telescope._extensions.agrolenslib")

local log = plenary.log.new({plugin = "agrolens", level = "info"})

local setup = function(ext_config, _)
    local config = vim.F.if_nil(ext_config, {patterns = {".git"}})

    -- redefine log if debug enabled
    if vim.F.if_nil(config.debug, false) then log = plenary.log.new({plugin = "agrolens", level = "debug"}) end
    agrolens.log = log
end

return telescope.register_extension({setup = setup, exports = {agrolens = function(opts) agrolens.run(opts) end}})
