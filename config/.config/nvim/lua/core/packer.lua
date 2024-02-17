vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	-- use({ 'rose-pine/neovim', as = 'rose-pine' })
	use('Mofiqul/dracula.nvim')
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('ThePrimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use('tpope/vim-obsession')
	use('tpope/vim-surround')
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

	use('williamboman/mason.nvim')
	use('williamboman/mason-lspconfig.nvim')
	use('mfussenegger/nvim-dap')
	use {
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim"
		}
	}
	use('folke/neodev.nvim')
	use('nvim-neotest/neotest-python')
	use('neovim/nvim-lspconfig')

	use('hrsh7th/nvim-cmp')
	use('hrsh7th/cmp-nvim-lsp')
	use('hrsh7th/cmp-nvim-lua')
	use('hrsh7th/cmp-nvim-lsp-signature-help')
	use('hrsh7th/cmp-vsnip')
	use('hrsh7th/cmp-buffer')
	use('hrsh7th/vim-vsnip')

	use{
		'nvim-tree/nvim-tree.lua',
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	}
end)
