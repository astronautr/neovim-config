return {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
                local treesitter_configs = require("nvim-treesitter.configs")

                treesitter_configs.setup({
                        ensure_installed = {
                                "lua",
                                "javascript",
                                "typescript",
                                "html",
                                "json",
                                "go",
                                "css",
                                "sql",
                                "yaml",
                                "xml",
                                "php",
                                "markdown",
                                "python",
                                "make"
                        },
                        highlight = { enable = true },
                        indent = { enable = true },
                })
        end
}

