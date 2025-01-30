require('options')

-- [[Менеджер пакетов]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- [[Настройка плагинов]]
local plugins = {
    -- Тема
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        pin = true,
        config = function()
            require("catppuccin").setup()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    -- Навигация между панелями tmux и vim
    {
        "christoomey/vim-tmux-navigator",
        pin = true,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    -- Поиск по проекту
    {
        'nvim-telescope/telescope.nvim',
        pin = true,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')
            local actions = require('telescope.actions')

            telescope.setup({
                defaults = {
                    -- Убираем игнорирование .git директории
                    file_ignore_patterns = {
                        "node_modules",
                        "vendor",
                        ".idea",
                        "^.git/",
                        ".digest"
                    },
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                    preview = {
                        treesitter = true
                    }
                },
                pickers = {
                    -- Вывод в поиске скрытых файлов
                    find_files = {
                        hidden = true
                    },
                    git_files = {
                        show_untracked = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end
                    },
                    buffers = {
                        sort_mru = true,
                        ignore_current_buffer = false,
                    },
                    current_buffer_fuzzy_find = {
                        skip_empty_lines = true,
                    },
                }
            })

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
            vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Find git files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find text' })
            vim.keymap.set('n', '<C-e>', builtin.buffers, { desc = 'Find buffers' })
            vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find, { desc = 'Search in current buffer' })
        end,
    },
    -- Подсветка синтаксиса, навигация, отступы
    {
        "nvim-treesitter/nvim-treesitter",
        pin = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects"
        },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                    "go",
                    "php",
                    "json",
                    "dockerfile",
                    "yaml",
                    "tsx",
                    "sql",
                    "markdown",
                    "jsdoc",
                    "gomod",
                    "gosum",
                    "fish",
                    "make",
                    "bash"
                },
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        pin = true,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            -- Mason Setup
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",       -- Lua
                    "ts_ls",        -- JavaScript/TypeScript
                    "html",         -- HTML
                    "cssls",        -- CSS
                    "gopls",        -- Go
                    "intelephense", -- PHP
                    "jsonls",       -- JSON
                    "yamlls",       -- YAML
                    "dockerls",     -- Docker
                    "marksman",     -- Markdown
                    "sqlls",        -- SQL
                    "eslint",       -- Форматирование eslint
                },
                automatic_installation = true,
            })

            -- Capabilities для автодополнения
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- LSP Setup
            local lspconfig = require("lspconfig")

            -- Базовая функция настройки с capabilities
            local function setup_lsp(server)
                lspconfig[server].setup({
                    capabilities = capabilities
                })
            end

            -- Lua с особыми настройками
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- Go с особыми настройками
            lspconfig.gopls.setup({
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    -- Автоисправление при сохранении
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll",
                    })
                end,
            })

            -- Настройка остальных серверов
            local servers = {
                "ts_ls",
                "html",
                "cssls",
                "intelephense",
                "jsonls",
                "yamlls",
                "dockerls",
                "marksman",
                "sqlls"
            }
            for _, server in ipairs(servers) do
                setup_lsp(server)
            end

            -- Маппинги
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

            -- LSP attachments
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })
        end,
    },
    -- Автодополнение
    {
        "hrsh7th/nvim-cmp",
        pin = true,
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "rafamadriz/friendly-snippets", -- добавляем коллекцию готовых сниппетов
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Загружаем сниппеты VSCode
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),

                    -- Добавляем навигацию по Tab
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                -- Улучшаем вид окна автодополнения
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- Настройка автодополнения для командной строки
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                    { name = 'cmdline' }
                })
            })
        end,
    },
    -- Форматирование через линтеры
    {
        "nvimtools/none-ls.nvim",
        pin = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier.with({
                        prefer_local = "node_modules/.bin",
                        condition = function(utils)
                            return utils.root_has_file({
                                ".prettierrc",
                                ".prettierrc.json",
                                ".prettierrc.yml",
                                ".prettierrc.yaml",
                                ".prettierrc.json5",
                                ".prettierrc.js",
                                "prettier.config.js",
                                ".prettierrc.mjs",
                                "prettier.config.mjs",
                                ".prettierrc.cjs",
                                "prettier.config.cjs"
                            })
                        end,
                        -- Указываем только нужные типы файлов
                        filetypes = {
                            "javascript",
                            "javascriptreact",
                            "typescript",
                            "typescriptreact",
                        },
                    })
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    async = false,
                                    filter = function(c)
                                        return c.name == "null-ls"
                                    end
                                })
                            end,
                        })
                    end
                end,
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
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
    {
        "akinsho/bufferline.nvim",
        version = "*",
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
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup()
        end
    },
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                providers = {
                    "lsp",
                    "treesitter",
                    "regex",
                },
                delay = 100,
                filetypes_denylist = {
                    "dirbuf",
                    "dirvish",
                    "fugitive",
                },
            })
        end,
    },
    {
        "echasnovski/mini.indentscope",
        version = false,
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end,
    },
    {
        "echasnovski/mini.pairs",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.pairs").setup({})
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    hijack_netrw_behavior = "open_default",
                    follow_current_file = {
                        enabled = true
                    }
                }
            })

            vim.keymap.set('n', '<C-n>', ':Neotree filesystem toggle left<CR>')
        end
    }
}

-- Загрузка плагинов
require("lazy").setup(plugins)
