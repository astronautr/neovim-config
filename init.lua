vim.cmd("set expandtab")
vim.cmd("set tabstop=4 softtabstop=4")
vim.cmd("set smartindent")
vim.cmd("set clipboard+=unnamed")
vim.cmd("set nu")
vim.cmd("set rnu")

-- Lazy Setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins setup
local plugins = {
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
        {
                'nvim-telescope/telescope.nvim', tag = '0.1.5',
                dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
        {
                "nvim-neo-tree/neo-tree.nvim",
                branch = "v3.x",
                dependencies = {
                        "nvim-lua/plenary.nvim",
                        "nvim-tree/nvim-web-devicons",
                        "MunifTanjim/nui.nvim",
                }
        },
        {
                'nvim-lualine/lualine.nvim',
                dependencies = { 'nvim-tree/nvim-web-devicons' }
        }
}
local opts = {}

require("lazy").setup(plugins, opts)

-- Loading modules
local builtin = require("telescope.builtin")
local treesitter_configs = require("nvim-treesitter.configs")

-- Activating plugins
require("catppuccin").setup()
require("lualine").setup({
        options = {
                theme = "dracula"
        }
})
vim.cmd.colorscheme "catppuccin"

-- Configuring Plugins
treesitter_configs.setup({
        ensure_installed = {"lua", "javascript", "typescript", "html", "json", "go", "css", "sql", "yaml", "xml"},
        highlight = { enable = true },
        indent = { enable = true },
})

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set('n', '<C-o>', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')
