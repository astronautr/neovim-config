return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"tsserver",
					"cssls",
					"html",
					"marksman",
					"intelephense",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({})
			lspconfig.gopls.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.cssls.setup({})
			lspconfig.html.setup({})
			lspconfig.marksman.setup({})
			lspconfig.intelephense.setup({})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.incoming_calls, {})
			vim.keymap.set("n", "go", vim.lsp.buf.outgoing_calls, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "gp", vim.lsp.buf.signature_help, {})
		end,
	},
}
