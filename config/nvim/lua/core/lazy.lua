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
			{ "j-hui/fidget.nvim",       opts = {},    tag = "legacy" },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	},
	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim",           opts = {} },
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
	{ "akinsho/bufferline.nvim",        requires = "nvim-tree/nvim-web-devicons" },
	-- {
	-- 	-- Set lualine as statusline
	-- 	"nvim-lualine/lualine.nvim",
	-- 	-- See `:help lualine.txt`
	-- 	opts = {
	-- 		options = {
	-- 			icons_enabled = true,
	-- 			theme = "dracula",
	-- 			component_separators = "|",
	-- 			section_separators = "",
	-- 		},
	-- 	},
	-- },
	{ "antoinemadec/FixCursorHold.nvim" },
	{ "nvim-tree/nvim-tree.lua" },
	{
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
		},
	},
	{ "nvim-neotest/neotest-python" },
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		main = "ibl",
		opts = {
			indent = { char = "┊" },
		},
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim",         opts = {} },
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
		"nvimtools/none-ls.nvim",
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
	{ "theHamsta/nvim-dap-virtual-text" },
	-- { "github/copilot.vim" },
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({})
		end,
	},
	{ "dcampos/nvim-snippy" },
	{ "dcampos/cmp-snippy" },
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{ "windwp/nvim-autopairs" },
	{ "onsails/lspkind.nvim" },
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{ "wsdjeg/vim-fetch" },
	{ "ray-x/lsp_signature.nvim" },
	{ "goolord/alpha-nvim" },
	{ "romgrk/barbar.nvim" },
	{
		"nvimdev/galaxyline.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	},
	{ "stevearc/dressing.nvim" },
	{ "ggandor/lightspeed.nvim" },
	{ "/rcarriga/nvim-notify" },
	{ "MunifTanjim/nui.nvim" },
	-- { "folke/noice.nvim" },
	{ "tpope/vim-repeat" },
	{ "wakatime/vim-wakatime" },
	{ "ThePrimeagen/git-worktree.nvim" },
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{ "ray-x/lsp_signature.nvim" },
}, {})
