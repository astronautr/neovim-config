vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.showmode = true

vim.opt.shiftwidth = 4
vim.opt.breakindent = true
vim.opt.linebreak = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.autowrite = true
vim.opt.confirm = true

vim.opt.clipboard = "unnamedplus"

-- [[Подключаем менеджер пакетов]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo(
            { { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\nPress any key to exit..." } },
            true,
            {}
        )
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- [[Настройка плагинов]]
local plugins = {
    -- Подсветка синтаксиса + синтаксическое дерево
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "json",
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx",
                "lua",
                "toml",
                "yaml",
            },
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            additional_vim_regex_highlighting = true
        },
    },
    -- Прыжки по определениям, форматирование, диагностика
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Глобальные функции vim, опциональное
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            }
        },
        config = function()
            -- Включить диагностику в редакторе
            vim.diagnostic.config({
                virtual_text = {
                    severity = {
                        min = vim.diagnostic.severity.WARN
                    }
                },
                signs = true,
                underline = true,
                update_in_insert = true,
                severity_sort = true,
                float = {
                    border = "rounded",
                }
            })

            require("lspconfig").lua_ls.setup {}
            require("lspconfig").ts_ls.setup {}
            require("lspconfig").gopls.setup {}

            require("lspconfig").eslint.setup({
                on_attach = function(_, bufnr)
                    -- Автоисправление при сохранении
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll",
                    })
                end,
            })

            -- Горячие клавиши для прыжков по определениям (помимо клавиш по-умолачанию)
            vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end)
            vim.keymap.set("n", "<leader>gD", function() vim.lsp.buf.declaration() end)

            vim.keymap.set('n', '<leader>f', function()
                vim.lsp.buf.format { async = true }
            end)

            -- Горячие клавиши для работы с диагностикой
            vim.keymap.set("n", "<leader>df", function() vim.diagnostic.open_float() end);
            vim.keymap.set("n", "<leader>d]", function() vim.diagnostic.goto_next() end);
            vim.keymap.set("n", "<leader>d[", function() vim.diagnostic.goto_prev() end);
        end
    },
    -- Автодополнение
    {
        'saghen/blink.cmp',
        version = '1.*',
        opts = {
            signature = { enabled = true },
            keymap = { preset = 'enter' },
            appearance = {
                nerd_font_variant = 'mono'
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    -- Навигация по проекту + поиск
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            {
                "<C-p>",
                "<cmd>lua require('fzf-lua').files()<cr>",
                desc = "Поиск файлов",
            },
            {
                "<C-e>",
                function()
                    require("fzf-lua").oldfiles({
                        cwd_only = true,
                    })
                end,
                desc = "Недавние файлы в текущей директории",
            },
            {
                "<C-f>",
                "<cmd>lua require('fzf-lua').live_grep()<cr>",
                desc = "Поиск текста в файлах",
            },
            {
                "<leader>dd",
                function()
                    require('fzf-lua').diagnostics_document()
                end
            },
            {
                "<leader>dw",
                function()
                    require('fzf-lua').diagnostics_workspace()
                end
            },
            {
                "<S-e>",
                function ()
                    require('fzf-lua').buffers()
                end
            }
        },
    },
    -- Дерево файлов
    {
        "nvim-neo-tree/neo-tree.nvim",
        pin = true,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    hijack_netrw_behavior = "open_default",
                    follow_current_file = {
                        enabled = true,
                    },
                },
            })

            vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle<CR>")
        end,
    },
    -- Общие клавиши навигации между панелями для tmux и vim
    {
        "christoomey/vim-tmux-navigator",
        pin = true,
        cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
        keys = {
            { "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    -- Подсветка отступов
    {
        "echasnovski/mini.indentscope",
        version = false,
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
    },
    -- Автоматичсое закрытие скобок и кавычек
    {
        "echasnovski/mini.pairs",
        opts = {
            modes = { insert = true, command = true, terminal = false },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { "string" },
            skip_unbalanced = true,
        },
    },
    -- Комментарии
    {
        "echasnovski/mini.comment",
    },
    -- Список открытых буферов и перемещение между ними
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
        },
        opts = {
            options = {
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            vim.opt.termguicolors = true
            require("bufferline").setup(opts)
        end,
    },
    -- Тема
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        pin = true,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}

-- Загрузка плагинов
require("lazy").setup(plugins)
