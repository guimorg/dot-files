-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
-- Highlights the yanked text
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Beautiful Yank function
function Complete_yank()
	local start_line = vim.fn.getpos("'<")[2]
	local end_line = vim.fn.getpos("'>")[2]
	local filename = vim.fn.expand("%")
	local decoration = string.rep("-", #filename + 1)

	local lines = {}
	for i = start_line, end_line do
		table.insert(lines, i .. " " .. vim.fn.getline(i))
	end

	local text = table.concat({ decoration, filename .. ":", decoration, "", unpack(lines) }, "\n")
	vim.fn.setreg("+", text)
end

vim.keymap.set("v", "<leader>y", ":lua Complete_yank()<CR>", { noremap = true })
