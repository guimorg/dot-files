require("oil").setup({
	default_file_explorer = true,
	view_options = {
		show_hidden = true,
		is_hidden_file = function(name, _)
			return vim.startswith(name, ".")
		end,
	},
	float = {
		padding = 2,
		border = "rounded",
	},
})

vim.keymap.set("n", "<leader>op", "<cmd>Oil<CR>", { desc = "[O]pen [P]arent directory" })
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "[P]roject [V]iew directory" })
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
