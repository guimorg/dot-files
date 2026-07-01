require("mason").setup()

require("mason-tool-installer").setup({
	ensure_installed = {
		"ty",
		"ruff",
		"gopls",
		"lua-language-server",
		"clangd",
		"bash-language-server",
		"json-lsp",
		"yaml-language-server",
		"terraform-ls",
		"tflint",
		"rust-analyzer",
		"trivy",
		"stylua",
	},
	auto_update = false,
	run_on_start = true,
})
