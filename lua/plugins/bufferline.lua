return {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
                { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
                { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
                { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete other buffers" },
                { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete buffers to the right" },
                { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete buffers to the left" },
                { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
                { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
                { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
                { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
        },
        offsets = {
                {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                },
        },
        config = function(_, opts)
                vim.opt.termguicolors = true
                require("bufferline").setup(opts)

                vim.api.nvim_create_autocmd("BufAdd", {
                        callback = function()
                                vim.schedule(function()
                                        pcall(nvim_bufferline)
                                end)
                        end,
                })
        end,
}
