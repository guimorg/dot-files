local M = {}

local servers = {
	"ty",
	"ruff",
	"gopls",
	"lua_ls",
	"clangd",
	"bashls",
	"jsonls",
	"yamlls",
	"terraformls",
	"tflint",
}

local server_cmds = {
	ty = "ty",
	ruff = "ruff",
	gopls = "gopls",
	lua_ls = "lua-language-server",
	clangd = "clangd",
	bashls = "bash-language-server",
	jsonls = "vscode-json-language-server",
	yamlls = "yaml-language-server",
	terraformls = "terraform-ls",
	tflint = "tflint",
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local nmap = function(keys, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
		end

		nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		nmap("K", vim.lsp.buf.hover, "Hover Documentation")
		nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

		nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		nmap("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")

		vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
			vim.lsp.buf.format()
		end, { desc = "Format current buffer with LSP" })
		nmap("<leader>f", ":Format<CR>", "[F]ormat")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

local enabled_servers = {}
for _, server in ipairs(servers) do
	local cmd = server_cmds[server]
	if cmd and vim.fn.executable(cmd) == 1 then
		table.insert(enabled_servers, server)
	end
end

if #enabled_servers > 0 then
	vim.lsp.enable(enabled_servers)
end

vim.api.nvim_create_user_command("LspRestart", function()
	vim.cmd("LspStop")
	vim.defer_fn(function()
		vim.cmd("LspStart")
	end, 500)
end, { desc = "Restart all LSP clients" })

vim.api.nvim_create_user_command("LspPython", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local python_clients = {}
	for _, client in ipairs(clients) do
		if client.name == "ty" or client.name == "pyright" or client.name == "ruff" then
			table.insert(python_clients, client.name)
		end
	end
	if #python_clients > 0 then
		vim.notify("Active Python LSP: " .. table.concat(python_clients, ", "), vim.log.levels.INFO)
	else
		vim.notify("No Python LSP clients active", vim.log.levels.WARN)
	end
end, { desc = "Show active Python LSP clients" })

require("core.lsp.mason")

return M
