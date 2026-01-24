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

function Complete_yank()
	local start_line = vim.fn.getpos("'<")[2]
	local end_line = vim.fn.getpos("'>")[2]
	local filename = vim.fn.expand("%")
	local decoration = string.rep("-", #filename + 1)

	local lines = {}
	for i = start_line, end_line do
		local line_content = vim.fn.getline(i)
		local line_num_width = #tostring(end_line)
		local formatted_line = string.format("%" .. line_num_width .. "d|%s", i, line_content)
		table.insert(lines, formatted_line)
	end

	local text = table.concat({ decoration, filename .. ":", decoration, "", table.concat(lines, "\n") }, "\n")
	vim.fn.setreg("+", text)
	print("📋 Copied " .. (end_line - start_line + 1) .. " lines with formatting")
end

vim.keymap.set("v", "<leader>y", ":lua Complete_yank()<CR>", { noremap = true, desc = "Copy code with line numbers" })

vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "[W]indow split [V]ertical" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "[W]indow [S]plit horizontal" })
vim.keymap.set("n", "<leader>wd", "<cmd>close<CR>", { desc = "[W]indow [D]elete/close" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "[W]indow focus left ([H])" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "[W]indow focus down ([J])" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "[W]indow focus up ([K])" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "[W]indow focus right ([L])" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "[W]indow balance sizes" })

vim.keymap.set("n", "<leader>gg", "<cmd>Git<CR>", { desc = "[G]it status (fu[G]itive)" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "[G]it [B]lame" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "[G]it [L]og" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "[G]it [D]iff" })

vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "[Q]uit [Q]uit all" })
vim.keymap.set("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "[Q]uit [Q]uit all without saving" })

vim.keymap.set("n", "<leader>hr", "<cmd>source $MYVIMRC<CR>", { desc = "[H]elp [R]eload config" })
vim.keymap.set("n", "<leader>hh", "<cmd>Telescope help_tags<CR>", { desc = "[H]elp [H]elp tags" })

vim.keymap.set("n", "<leader>cc", "<cmd>Commentary<CR>", { desc = "[C]ode [C]omment" })
vim.keymap.set("v", "<leader>cc", "<cmd>Commentary<CR>", { desc = "[C]ode [C]omment" })

vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "[T]ab [N]ew" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "[T]ab [C]lose" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "[T]ab [O]nly (close others)" })
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
