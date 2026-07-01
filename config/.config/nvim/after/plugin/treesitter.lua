-- nvim-treesitter main branch: just installs parsers + queries.
-- Highlighting and other features are handled by nvim's built-in treesitter API.
require("nvim-treesitter").install({
	"bash",
	"c",
	"go",
	"hcl",
	"javascript",
	"json",
	"lua",
	"python",
	"query",
	"rust",
	"terraform",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
})

-- Enable treesitter highlighting per filetype.
-- markdown excluded: nvim 0.12.2 bug where the markdown injection engine calls
-- :range() on a nil TSNode (fenced_code_block_delimiter + conceal_lines predicate).
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"c",
		"go",
		"hcl",
		"javascript",
		"json",
		"lua",
		"python",
		"query",
		"rust",
		"terraform",
		"tsx",
		"typescript",
		"vim",
		"help",
		"yaml",
	},
	callback = function()
		vim.treesitter.start()
	end,
})

-- Textobjects (nvim-treesitter-textobjects main branch uses direct function API)
require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local to_select = require("nvim-treesitter-textobjects.select")
local to_move = require("nvim-treesitter-textobjects.move")
local to_swap = require("nvim-treesitter-textobjects.swap")

-- Select
vim.keymap.set({ "x", "o" }, "aa", function() to_select.select_textobject("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ia", function() to_select.select_textobject("@parameter.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "af", function() to_select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() to_select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() to_select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() to_select.select_textobject("@class.inner", "textobjects") end)

-- Move
vim.keymap.set({ "n", "x", "o" }, "]m", function() to_move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]]", function() to_move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]M", function() to_move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "][", function() to_move.goto_next_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[m", function() to_move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[[", function() to_move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[M", function() to_move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[]", function() to_move.goto_previous_end("@class.outer", "textobjects") end)

-- Swap
vim.keymap.set("n", "<leader>a", function() to_swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "<leader>A", function() to_swap.swap_previous("@parameter.inner") end)
