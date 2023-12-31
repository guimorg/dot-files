vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")

require("nvim-tree").setup({
	view = {
		adaptive_size = true,
	},
	filters = {
		dotfiles = false,
		custom = { "^.git$" },
	},
})

local function open_tab_silent(node)
	local api = require("nvim-tree.api")

	api.node.open.tab(node)
	vim.cmd.tabprev()
end
vim.keymap.set("n", "T", open_tab_silent, { desc = "Open Tab Silent" })
