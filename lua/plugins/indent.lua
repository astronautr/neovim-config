return {
        {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                        require("ibl").setup()
                end,
                opts = {
                        indent = {
                                char = "│",
                                tab_char = "│",
                        },
                        scope = { enabled = false },
                        exclude = {
                                filetypes = {
                                        "help",
                                        "alpha",
                                        "dashboard",
                                        "neo-tree",
                                        "Trouble",
                                        "trouble",
                                        "lazy",
                                        "mason",
                                        "notify",
                                        "toggleterm",
                                        "lazyterm",
                                },
                        },
                },
                main = "ibl",
        },
        {
                "echasnovski/mini.indentscope",
                version = false,
                opts = {
                        symbol = "│",
                        options = {
                                try_as_border = true,
                        },
                },
        },
}
