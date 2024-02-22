local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("agrolens.nvim requires nvim-telescope/telescope.nvim")
end

local has_plenary, plenary = pcall(require, "plenary")
if not has_plenary then
    error("This extension requires plenary")
    return
end

local agrolens = require("telescope._extensions.agrolenslib")

local setup = function(ext_config, _)
    local config = vim.F.if_nil(ext_config, { debug = false })

    -- redefine log if debug enabled
    if vim.F.if_nil(config.debug, false) then
        agrolens.log = plenary.log.new({ plugin = "agrolens", level = "debug" })
    end

    agrolens.telescope_config = ext_config

    if agrolens.telescope_config.disable_devicons ~= false then
        local has_devicons
        has_devicons, agrolens.devicons = pcall(require, "nvim-web-devicons")
        if has_devicons then
            if not agrolens.devicons.has_loaded() then
                agrolens.devicons.setup()
            end
        end
    end
end

return telescope.register_extension({
    setup = setup,
    exports = {
        agrolens = function(opts)
            agrolens.run(opts)
        end,
    },
})
