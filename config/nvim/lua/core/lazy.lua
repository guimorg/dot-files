require("lazy").setup({
	-- Git related plugins
	"tpope/vim-fugitive",
	-- GitHub integration for omni-completion (issues or project collaborator usernames)
	-- when editing a commit message
	"tpope/vim-rhubarb",

	-- automatic detection of the identation stype used in a file adjustinf shiftwidth and tabstop
	"tpope/vim-sleuth",

	"folke/trouble.nvim",

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	},
	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	-- { -- Theme inspired by Atom
	-- 'navarasu/onedark.nvim',
	-- priority = 1000,
	-- config = function()
	--  vim.cmd.colorscheme 'onedark'
	-- end,
	-- },
	{
		"Mofiqul/dracula.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("dracula")
		end,
	},
	{ "ThePrimeagen/harpoon" },
	{ "mbbill/undotree" },
	{ "tpope/vim-obsession" },
	{ "tpope/vim-surround" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "akinsho/bufferline.nvim", requires = "nvim-tree/nvim-web-devicons" },
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = "dracula",
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{ "antoinemadec/FixCursorHold.nvim", lazy = true },
	{ "nvim-tree/nvim-tree.lua" },
	{ "nvim-neotest/neotest" },
	{ "nvim-neotest/neotest-python" },
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = "┊",
			show_trailing_blankline_indent = false,
		},
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"mfussenegger/nvim-dap",
	},
	{
		"mfussenegger/nvim-dap-python",
	},
	{
		"rcarriga/nvim-dap-ui",
	},
	{ "nvim-telescope/telescope-dap.nvim" },
	{ "Pocco81/DAPInstall.nvim" },
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "github/copilot.vim" },
	{ "dcampos/nvim-snippy" },
	{ "windwp/nvim-autopairs" },
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
}, {})
