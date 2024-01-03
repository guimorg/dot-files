-- vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = "[C]opilot panel" })
-- vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = "[C]opilot [E]nable" })
-- vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = "[C]opilot [D]isable" })
--
-- vim.g.copilot_enabled = false
-- vim.g.copilot_filetypes = { python = true }
require("copilot").setup({
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
		layout = {
			position = "bottom", -- | top | left | right
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = false,
		debounce = 75,
		keymap = {
			accept = "<M-l>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
	copilot_node_command = "node", -- Node.js version must be > 18.x
	server_opts_overrides = {},
})

-- write a function for hello world:

local copilot_suggestion = require("copilot.suggestion")

vim.keymap.set("n", "<leader>ct", copilot_suggestion.toggle_auto_trigger, { desc = "[C]opilot [T]oggle Suggestion" })
vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = "[C]opilot [P]anel" })
