require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	integrations = {
		treesitter = true,
		telescope = { enabled = true },
		lualine = true,
		gitsigns = true,
		indent_blankline = { enabled = true },
		which_key = true,
		mini = { enabled = true },
		neotest = true,
		trouble = true,
		harpoon = true,
	},
})

vim.cmd.colorscheme("catppuccin")

-- Named groups for dashboard (avoids coupling alpha.lua to theme internals)
vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#CBA6F7", bold = true })
vim.api.nvim_set_hl(0, "DashboardDate", { fg = "#89DCEB" })
vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = "#FAB387", bold = true })
vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#7F849C", italic = true })
vim.api.nvim_set_hl(0, "DashboardFg", { fg = "#CDD6F4" })
