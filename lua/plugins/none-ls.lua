return {
        "nvimtools/none-ls.nvim",
        config = function()
                local none_ls = require("null-ls")

                none_ls.setup({
                        sources = {
                                none_ls.builtins.formatting.stylua,
                                none_ls.builtins.diagnostics.eslint,
                                none_ls.builtins.formatting.eslint,
                                none_ls.builtins.diagnostics.golangci_lint,
                                none_ls.builtins.formatting.goimports,
                                none_ls.builtins.diagnostics.stylelint,
                                none_ls.builtins.formatting.stylelint,
                                none_ls.builtins.formatting.phpcsfixer,
                                none_ls.builtins.diagnostics.phpstan,
                                none_ls.builtins.formatting.fixjson,
                                none_ls.builtins.diagnostics.jsonlint,
                                none_ls.builtins.diagnostics.checkmake,
                                none_ls.builtins.formatting.shfmt,
                                none_ls.builtins.diagnostics.shellcheck,
                        },
                })

                vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, {})
        end,
}
