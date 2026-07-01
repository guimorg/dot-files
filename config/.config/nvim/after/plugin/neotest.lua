local ok, neotest = pcall(require, "neotest")
if not ok then
	return
end

neotest.setup({
	adapters = {
		require("neotest-python")({
			args = { "--no-cov" },
		}),
		require("neotest-go"),
		require("neotest-rust")({ args = { "--no-capture" } }),
	},
})

vim.keymap.set("n", "<leader>tcf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "[T]est [C]urrent [F]ile" })

vim.keymap.set("n", "<leader>tn", function()
	neotest.run.run()
	neotest.summary.open()
end, { desc = "[T]est [N]earest" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output.open({ last_run = true, enter = true })
end, { desc = "[T]est [O]utput" })

vim.keymap.set("n", "<leader>tS", function()
	neotest.summary.toggle()
end, { desc = "[T]est [S]ummary toggle" })

vim.keymap.set("n", "<leader>tl", function()
	neotest.run.run_last({ enter = true })
	neotest.output.open({ last_run = true, enter = true })
end, { desc = "[T]est run [L]ast" })
