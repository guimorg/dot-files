require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	numhl = true,
	linehl = false,
	word_diff = false,
	current_line_blame_opts = {
		delay = 2000,
		virt_text_pos = "eol",
	},
})

local gs = require("gitsigns")
vim.keymap.set("n", "]g", gs.next_hunk, { desc = "Next git hunk" })
vim.keymap.set("n", "[g", gs.prev_hunk, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>gh", gs.preview_hunk, { desc = "[G]it [H]unk preview" })
vim.keymap.set("n", "<leader>gS", gs.stage_hunk, { desc = "[G]it [S]tage hunk" })
vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[G]it [U]ndo stage hunk" })
vim.keymap.set("n", "<leader>gB", gs.blame_line, { desc = "[G]it [B]lame line (inline)" })
