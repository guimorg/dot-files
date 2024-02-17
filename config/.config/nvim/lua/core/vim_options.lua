vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For clever completion with the :find command
vim.o.path = vim.o.path .. '**'

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = {"menuone", "noselect", "noinsert", "preview"}
vim.opt.shortmess = vim.opt.shortmess + { c = true }

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.env.PATH = vim.env.PATH .. ":" .. "${HOME}/.pyenv/shims"
