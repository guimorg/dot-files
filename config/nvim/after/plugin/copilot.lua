vim.keymap.set("n", "<leader>cp", ":Copilot panel<CR>", { desc = "[C]opilot panel" })
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { desc = "[C]opilot [E]nable" })
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { desc = "[C]opilot [D]isable" })

vim.g.copilot_enabled = false
vim.g.copilot_filetypes = { python = true }
