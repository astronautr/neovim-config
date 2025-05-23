vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.shiftwidth = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.showmode = false

vim.opt.breakindent = true
vim.opt.linebreak = true

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.autowrite = true
vim.opt.confirm = true

vim.opt.clipboard = "unnamedplus"

vim.keymap.set({ "n", "v" }, "<leader>w", ":bd<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v", "i" }, "<C-a>", function()
    vim.lsp.buf.format({})
    vim.cmd("wa")
end)

vim.keymap.set("n", "<M-l>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<M-h>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<M-k>", ":resize -2<CR>")
vim.keymap.set("n", "<M-j>", ":resize +2<CR>")

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
            vim.keymap.set("n", "<leader>gt", function() vim.lsp.buf.type_definition() end)

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
            completion = {
                documentation = { auto_show = true },
                ghost_text = { enabled = true }
            },
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
                "grr",
                "<cmd>lua require('fzf-lua').lsp_references()<cr>"
            },
            {
                "gri",
                "<cmd>lua require('fzf-lua').lsp_implementations()<cr>"
            },
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
                function()
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
                separator_style = "slant"
            },
        },
        config = function(_, opts)
            vim.opt.termguicolors = true
            require("bufferline").setup(opts)
        end,
    },
    -- Комментарии
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    -- Статусная строка
    {
        "nvim-lualine/lualine.nvim",
        pin = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = false,
                    disabled_filetypes = { "neo-tree" }
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = { modified = "[+]", readonly = "[-]", unnamed = "[No Name]" },
                        },
                    },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
    -- Навигация по функциям в текущем файле
    {
        'stevearc/aerial.nvim',
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("aerial").setup({
                on_attach = function(bufnr)
                    vim.keymap.set("n", "<leader>?", "<cmd>AerialToggle<CR>", { buffer = bufnr })
                end,
            })
        end
    },
    -- Показать контекст в коде, будь то функция или блок if / switch, внутри которого находимся
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 3
        }
    },
    -- Копировать путь до файла
    {
        "ohakutsu/socks-copypath.nvim",
        config = function()
            require("socks-copypath").setup()

            vim.keymap.set({ "n", "v" }, "<leader>cp", "<cmd>CopyPath<cr>")
            vim.keymap.set({ "n", "v" }, "<leader>cr", "<cmd>CopyRelativePath<cr>")
            vim.keymap.set({ "n", "v" }, "<leader>cn", "<cmd>CopyFileName<cr>")
        end,
    },
    -- Git blame
    {
        "lewis6991/gitsigns.nvim",
        event = "BufEnter",
        cmd = "Gitsigns",
        keys = {
            { "<leader>gb", "<cmd>Gitsigns blame<cr>",        mode = { "n", "v" } },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",   mode = { "n", "v" } },
            { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", mode = { "n", "v" } },
        },
        opts = {
            current_line_blame = true,
            current_line_blame_opts = { delay = 300 }
        }
    },
    -- Открытие файла на git сервере
    {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        opts = {},
        keys = {
            { "<leader>gl", "<cmd>GitLink<cr>",  mode = { "n", "v" }, desc = "Yank git link" },
            { "<leader>gL", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
        },
        config = function()
            require("gitlinker").setup({
                router = {
                    browse = {
                        ["^stash%.msk%.avito%.ru"] = function(lk)
                            local org, repo
                            local pattern = ".*:7999/([^/]+)/([^/]+)%.git"

                            -- Считываем пространство и название проекта
                            org, repo = string.match(lk.remote_url, pattern)

                            -- Формируем URL BitBucket
                            local url = "https://stash.msk.avito.ru/projects/" .. org .. "/repos/" .. repo
                            url = url .. "/browse/" .. lk.file
                            url = url .. "?at=" .. lk.rev

                            -- Добавляем номера строк
                            if lk.lstart == lk.lend then
                                url = url .. "#" .. lk.lstart
                            else
                                -- Диапозон url
                                url = url .. "#" .. lk.lstart .. "-" .. lk.lend
                            end

                            return url
                        end,
                    },
                }
            })
        end
    },
    -- Всегда центрировать код (авто `zz`)
    {
        'arnamak/stay-centered.nvim',
        opts = {}
    },
    -- UI
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup()
        end
    },
    -- Тема
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "moon"
            })

            vim.cmd.colorscheme("rose-pine")
        end
    },
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     pin = true,
    --     config = function()
    --         require("catppuccin").setup({
    --             flavour = "macchiato",
    --         })
    --         vim.cmd.colorscheme("catppuccin")
    --     end,
    -- },
}

-- Загрузка плагинов
require("lazy").setup(plugins)
