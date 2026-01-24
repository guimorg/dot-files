local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	capabilities = capabilities,
	settings = {
		diagnosticMode = "workspace",
	},
}
