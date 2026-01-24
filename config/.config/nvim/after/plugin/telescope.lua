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
			"--smart-case"
		},
		previewer = true,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			additional_args = function(_ts)
				return {"--hidden"}
			end
		}
	}
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

vim.keymap.set("n", "<leader>pp", function()
	require("telescope.builtin").find_files({
		cwd = require("telescope.utils").buffer_dir(),
		prompt_title = "Project Files",
		find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
	})
end, { desc = "[P]roject [P]roject switch" })
vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, { desc = "[P]roject [F]ind file" })
vim.keymap.set("n", "<leader>ps", require("telescope.builtin").live_grep, { desc = "[P]roject [S]earch" })
vim.keymap.set("n", "<leader>pb", require("telescope.builtin").buffers, { desc = "[P]roject [B]uffers" })

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]ile" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "[F]ind [R]ecent files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })

vim.keymap.set("n", "<leader>bb", require("telescope.builtin").buffers, { desc = "[B]uffer [B]uffer list" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "[B]uffer [P]revious" })

vim.keymap.set("n", "<leader>ss", require("telescope.builtin").live_grep, { desc = "[S]earch [S]earch project" })
vim.keymap.set("n", "<leader>sp", require("telescope.builtin").live_grep, { desc = "[S]earch [P]roject" })

vim.keymap.set("n", "<leader>op", "<cmd>NvimTreeToggle<CR>", { desc = "[O]pen [P]roject sidebar" })

pcall(require("telescope").load_extension, "git_worktree")
vim.keymap.set(
	"n",
	"<leader>ws",
	require("telescope").extensions.git_worktree.git_worktrees,
	{ desc = "[W]orktree [S]witch" }
)
vim.keymap.set(
	"n",
	"<leader>wc",
	require("telescope").extensions.git_worktree.create_git_worktree,
	{ desc = "[W]orktree [C]reate" }
)
