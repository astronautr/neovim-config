return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set({ "n", "v" }, "<leader>gb", ":Git blame <CR>")
			vim.keymap.set({ "n", "v" }, "<leader>gg", ":Gvdiffsplit <CR>")
			vim.keymap.set({ "n", "v" }, "<leader>go", ":GBrowse <CR>")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()

			vim.keymap.set({ "n", "v" }, "<leader>gp", ":Gitsigns preview_hunk <CR>", {})
			vim.keymap.set({ "n", "v" }, "<leader>gt", ":Gitsigns toggle_current_line_blame <CR>", {})
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					vim.cmd("Gitsigns toggle_current_line_blame")
				end,
			})
		end,
	},
}
