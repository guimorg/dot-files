local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
		}),
	},
})

require("neodev").setup({
	library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
})

vim.keymap.set("n", "<localleader>tcf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "[T]est [C]urrent [F]ile" })
vim.keymap.set("n", "<localleader>tn", function()
	neotest.run.run()
	neotest.summary.open()
end, { desc = "[T]est [N]earest" })
vim.keymap.set("n", "<localleader>to", function()
	neotest.output.open({ last_run = true, enter = true })
end, { desc = "[T]est [O]utput window" })
vim.keymap.set("n", "<localleader>ts", function()
	neotest.summary.toggle()
end, { desc = "[T]est [S]ummary window" })
vim.keymap.set("n", "<localleader>tl", function()
	neotest.run.run_last({ enter = true })
	neotest.output.open({ last_run = true, enter = true })
end, { desc = "[T]est [L]ast" })
vim.keymap.set("n", "<localleader>tfd", function()
	neotest.run.run({ strategy = "dap" })
end, { desc = "[T]est [F]ile [D]ap" })
