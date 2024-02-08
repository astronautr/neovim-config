return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")

			require("telescope").setup({
				pickers = {
					oldfiles = {
						cwd_only = true,
					},
				},
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
			})

			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fl", builtin.grep_string, {})
			vim.keymap.set({"n", "v"}, "<leader>ft", builtin.treesitter, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set({ "n", "v" }, "<leader>fr", builtin.oldfiles, {})
			vim.keymap.set({ "n", "v" }, "<leader>fd", builtin.diagnostics, {})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
