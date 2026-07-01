require("lazy").setup({
	-- ── Core utilities ────────────────────────────────────────────────────
	"tpope/vim-sleuth",
	"tpope/vim-repeat",
	"tpope/vim-obsession",
	"wsdjeg/vim-fetch",
"christoomey/vim-tmux-navigator",
	{ "NoahTheDuke/vim-just", ft = "just" },
	{
		"cappyzawa/trim.nvim",
		event = "VeryLazy",
		opts = { ft_blocklist = { "markdown" } },
	},

	-- ── Colorscheme ───────────────────────────────────────────────────────
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},

	-- ── File explorer ─────────────────────────────────────────────────────
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- ── Icons ─────────────────────────────────────────────────────────────
	"nvim-tree/nvim-web-devicons",

	-- ── Status line ───────────────────────────────────────────────────────
	{ "nvim-lualine/lualine.nvim" },

	-- ── Git ───────────────────────────────────────────────────────────────
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	{ "lewis6991/gitsigns.nvim" },
	{ "ThePrimeagen/git-worktree.nvim" },

	-- ── UI ────────────────────────────────────────────────────────────────
	{ "folke/which-key.nvim", opts = {} },
	{ "stevearc/dressing.nvim" },
	{ "MunifTanjim/nui.nvim" },
	{ "goolord/alpha-nvim" },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { indent = { char = "┊" } },
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ "folke/trouble.nvim" },
	{ "mbbill/undotree" },
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{ "antoinemadec/FixCursorHold.nvim" },

	-- ── LSP tooling ───────────────────────────────────────────────────────
	{ "williamboman/mason.nvim" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ "j-hui/fidget.nvim", opts = {} },

	-- ── Completion ────────────────────────────────────────────────────────
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_icon_theme = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
		},
	},

	-- ── AI ────────────────────────────────────────────────────────────────
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<M-l>",
					accept_word = "<M-w>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<M-e>",
				},
			},
			panel = { enabled = false },
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			provider = "claude",
			providers = {
				claude = {
					endpoint = "https://api.anthropic.com",
					model = "claude-sonnet-4-6",
					extra_request_body = {
						temperature = 0,
						max_tokens = 8192,
					},
				},
			},
		},
	},

	-- ── Navigation ────────────────────────────────────────────────────────
	{ "ThePrimeagen/harpoon" },
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- ── Editing ───────────────────────────────────────────────────────────
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},

	-- ── Treesitter ────────────────────────────────────────────────────────
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		},
		build = ":TSUpdate",
	},

	-- ── Testing ───────────────────────────────────────────────────────────
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"antoinemadec/FixCursorHold.nvim",
		},
	},
	{ "rouge8/neotest-rust" },
	{ "nvim-neotest/neotest-go" },
	{ "nvim-neotest/neotest-python" },

	-- ── Language-specific ─────────────────────────────────────────────────
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup({
				lsp_cfg = false,
				goimports = "gopls",
				gofmt = "gopls",
				tag_transform = false,
				test_dir = "",
				comment_placeholder = "   ",
				lsp_keymaps = false,
				lsp_gofumpt = true,
				dap_debug = false,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
