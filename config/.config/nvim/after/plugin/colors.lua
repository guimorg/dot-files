-- vim.cmd[[colorscheme dracula]]
require("dracula").setup({
	transparent_bg = true
})
vim.cmd.colorscheme("dracula")

vim.api.nvim_set_hl(0, "DraculaPurple", { fg = "#BD93F9", bold = true })
vim.api.nvim_set_hl(0, "DraculaCyan", { fg = "#8BE9FD" })
vim.api.nvim_set_hl(0, "DraculaOrange", { fg = "#FFB86C", bold = true })
vim.api.nvim_set_hl(0, "DraculaFg", { fg = "#F8F8F2" })
vim.api.nvim_set_hl(0, "DraculaComment", { fg = "#6272A4", italic = true })
