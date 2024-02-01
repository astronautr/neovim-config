return {
        {
                "lukas-reineke/indent-blankline.nvim",
                config = function(_, opts)
                        require("ibl").setup(opts)
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
                                        "dashboard", "neo-tree",
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
                config = function (_, opts)
                        local indent = require("mini.indentscope")

                        indent.gen_animation.none()
                        indent.setup(opts)
                end,
                opts = {
                        symbol = "│",
                        options = {
                                try_as_border = true,
                        },
                },
        },
}
