require("mason").setup()

local tools_to_install = {
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
	"stylua",
}

require("mason-tool-installer").setup({
	ensure_installed = tools_to_install,
	auto_update = false,
	run_on_start = true,
})

require("go").setup({
	lsp_cfg = false,
	goimports = "gopls",
	gofmt = "gopls",
	tag_transform = false,
	test_dir = "",
	comment_placeholder = "   ",
	lsp_keymaps = false,
	lsp_gofumpt = true,
	dap_debug = true,
})
