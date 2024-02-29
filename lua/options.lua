vim.cmd("set expandtab")
vim.cmd("set tabstop=4 softtabstop=4")
vim.cmd("set smartindent")
vim.cmd("set clipboard+=unnamed")
vim.cmd("set nu")
vim.cmd("set rnu")
vim.cmd("set noswapfile")
vim.cmd("set nobackup")

vim.o.mouse = "a"

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set({ "n", "v" }, "<M-K>", ":m .-2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<M-J>", ":m .+1<CR>", { noremap = true, silent = true })
---
vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-j>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":resize +2<CR>", { noremap = true, silent = true })

local function saveAndExecute()
	vim.lsp.buf.format({})
	vim.cmd("wa")
end

vim.keymap.set({ "n", "v", "i" }, "<C-s>", saveAndExecute, { noremap = true, silent = true })

vim.api.nvim_create_user_command("Vb", function(opts)
	vim.cmd("vert sb " .. opts.args)
end, { nargs = 1 })
