vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append("deps/mini.nvim")
vim.cmd([[runtime! plugin/nvim-treesitter.lua]])

vim.cmd([[au BufRead,BufNewFile *.conf set filetype=hocon]])
vim.cmd([[au BufRead,BufNewFile *.gleam set filetype=gleam]])

vim.o.swapfile = false
vim.bo.swapfile = false

require("mini.test").setup()

local parsers = {
    "c",
    "cpp",
    "dockerfile",
    "glsl",
    "go",
    "groovy",
    "lua",
    "make",
    "perl",
    "php",
    "python",
    "ruby",
    "rust",
    "toml",
    "yaml",
}

local ts = require("nvim-treesitter")
ts.install(parsers):wait(300000)
