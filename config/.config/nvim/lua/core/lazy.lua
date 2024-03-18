require("lazy").setup({
	"christoomey/vim-tmux-navigator",
	-- Git related plugins
	"tpope/vim-fugitive",
	-- GitHub integration for omni-completion (issues or project collaborator usernames)
	-- when editing a commit message
	"tpope/vim-rhubarb",

	-- automatic detection of the identation stype used in a file adjustinf shiftwidth and tabstop
	"tpope/vim-sleuth",
	{
		"cappyzawa/trim.nvim",
		event = "VeryLazy",
		opts = {
			ft_blocklist = { "markdown" },
		},
	},

	"folke/trouble.nvim",

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{ 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
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
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opt = { history = true, updateevents = "TextChanged,TextChangedI" },
			},
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},
	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim",      opts = {} },
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
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
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
	{ "ggandor/leap.nvim" },
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
	{ "tjdevries/colorbuddy.nvim" },
	{ "stevearc/oil.nvim" }
}, {})
