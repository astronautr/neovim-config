return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"gbprod/none-ls-shellcheck.nvim",
	},
	config = function()
		local none_ls = require("null-ls")

		none_ls.setup({
			sources = {
				none_ls.builtins.formatting.stylua,
				require("none-ls.diagnostics.eslint"),
				require("none-ls.formatting.eslint"),
				none_ls.builtins.diagnostics.golangci_lint,
				none_ls.builtins.formatting.goimports,
				none_ls.builtins.diagnostics.stylelint,
				none_ls.builtins.formatting.stylelint,
				none_ls.builtins.formatting.phpcsfixer,
				none_ls.builtins.diagnostics.phpstan,
				-- none_ls.builtins.formatting.jsonls,
				-- none_ls.builtins.diagnostics.jsonls,
				none_ls.builtins.diagnostics.checkmake,
				none_ls.builtins.formatting.shfmt,
				none_ls.builtins.diagnostics.hadolint,
				none_ls.builtins.diagnostics.yamllint,
				none_ls.builtins.formatting.yamlfix,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, {})
	end,
}
