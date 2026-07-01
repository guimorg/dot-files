require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		previewer = true,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
	},
	pickers = {
		find_files = { hidden = true },
		live_grep = {
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "git_worktree")

local builtin = require("telescope.builtin")

-- Recent / buffers
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

-- Find
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]ile" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })

-- Search
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

-- Project
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]ind file" })
vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "[P]roject [S]earch" })
vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "[P]roject [B]uffers" })

-- Buffers
vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "[B]uffer [B]uffer list" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })

-- Help
vim.keymap.set("n", "<leader>hh", builtin.help_tags, { desc = "[H]elp [H]elp tags" })

-- Git worktrees (under <leader>gw* to avoid conflict with <leader>w* window maps)
vim.keymap.set(
	"n",
	"<leader>gww",
	require("telescope").extensions.git_worktree.git_worktrees,
	{ desc = "[G]it [W]orktree s[W]itch" }
)
vim.keymap.set(
	"n",
	"<leader>gwc",
	require("telescope").extensions.git_worktree.create_git_worktree,
	{ desc = "[G]it [W]orktree [C]reate" }
)
