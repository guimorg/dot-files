local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
	capabilities = capabilities,
}
