local dap_breakpoint = {
	error = {
		text = "🟥",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "",
	},
	rejected = {
		text = "",
		texthl = "LspDiagnosticsSignHint",
		linehl = "",
		numhl = "",
	},
	stopped = {
		text = "⭐️",
		texthl = "LspDiagnosticsSignInformation",
		linehl = "DiagnosticUnderlineInfo",
		numhl = "LspDiagnosticsSignInformation",
	},
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

require("nvim-dap-virtual-text").setup({
	commented = true,
})

local dap, dapui = require("dap"), require("dapui")
dapui.setup({}) -- use default
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("dap-python").setup("python", {})
vim.keymap.set("n", "<leader>dct", '<cmd>lua require"dap".continue()<CR>', { desc = "[D]ap [C]on[T]inue" })
vim.keymap.set("n", "<leader>dsv", '<cmd>lua require"dap".step_over()<CR>', { desc = "[D]ap [S]tep o[V]er" })
vim.keymap.set("n", "<leader>dsi", '<cmd>lua require"dap".step_into()<CR>', { desc = "[D]ap" })
vim.keymap.set("n", "<leader>dso", '<cmd>lua require"dap".step_out()<CR>', { desc = "[D]ap [S]tep [O]ut" })
vim.keymap.set("n", "<leader>dtb", '<cmd>lua require"dap".toggle_breakpoint()<CR>', { desc = "[D]ap [T]oggle [B]reakpoint" })

vim.keymap.set("n", "<leader>dsc", '<cmd>lua require"dap.ui.variables".scopes()<CR>', { desc = "[D]ap [S][C]opes" })
vim.keymap.set("n", "<leader>dhh", '<cmd>lua require"dap.ui.variables".hover()<CR>', { desc = "[D]ap [H]over" })
vim.keymap.set("v", "<leader>dhv", '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', { desc = "[D]ap [H]over [V]isual" })

vim.keymap.set("n", "<leader>duh", '<cmd>lua require"dap.ui.widgets".hover()<CR>', { desc = "[D]ap [U]i [H]over" })
vim.keymap.set(
	"n",
	"<leader>duf",
	"<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
	{ desc = "[D]ap [U]i [F]loat scopes" }
)

vim.keymap.set(
	"n",
	"<leader>dsbr",
	'<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
	{ desc = "[D]ap [S]et [B][R]eakpoint" }
)
vim.keymap.set(
	"n",
	"<leader>dsbm",
	'<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
	{ desc = "[D]ap [S]et [B]reakpoint [M]essage" }
)
vim.keymap.set("n", "<leader>dro", '<cmd>lua require"dap".repl.open()<CR>', { desc = "[D]ap [R]epl [O]pen" })
vim.keymap.set("n", "<leader>drl", '<cmd>lua require"dap".repl.run_last()<CR>', { desc = "[D]ap [R]epl open [L]ast" })

-- telescope-dap
vim.keymap.set("n", "<leader>dcc", '<cmd>lua require"telescope".extensions.dap.commands{}<CR>', { desc = "[D]ap [C]ommands" })
vim.keymap.set("n", "<leader>dco", '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>', { desc = "[D]ap [C][O]nfigurations" })
vim.keymap.set("n", "<leader>dlb", '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', { desc = "[D]ap [L]ist [B]reakpoints" })
vim.keymap.set("n", "<leader>dv", '<cmd>lua require"telescope".extensions.dap.variables{}<CR>', { desc = "[D]ap [V]ariables" })
vim.keymap.set("n", "<leader>df", '<cmd>lua require"telescope".extensions.dap.frames{}<CR>', { desc = "[D]ap [F]rames" })
