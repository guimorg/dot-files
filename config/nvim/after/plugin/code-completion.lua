local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end
	-- vim.lsp.buf.format({ timeout_ms = 5000 })
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
	nmap("<leader>f", ":Format<CR>", "[F]ormat")
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	pyright = {},
	bashls = {},
	tflint = {},
	terraformls = {},
	yamlls = {},
	jsonls = {},
	-- rust_analyzer = {},
	-- tsserver = {},

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function lsp_server_config(server_name)
	local config = {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = servers[server_name],
	}
	return config
end

local server_names = vim.tbl_keys(servers)
for _, server_name in ipairs(server_names) do
	local success, server_config = pcall(lsp_server_config, server_name)
	if success then
		require("lspconfig")[server_name].setup(server_config)
	else
		vim.notify("Error setting up LSP for " .. server_name)
	end
end

require("neodev").setup()

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
	priority = {
		pyright = 1,
		yamlls = 2,
		jsonls = 3,
		bashls = 4,
		terraformls = 5,
		tflint = 6,
	},
})

luasnip.config.setup({})
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

cmp.setup({
	experimental = {
		native_menu = false,
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol",
			max_width = 50,
			ellipsis_char = "...",
			symbol_map = { Copilot = "" },
		}),
	},
	enabled = function()
		local context = require("cmp.config.context")
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			require("copilot_cmp.comparators").prioritize,
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,

			-- copied from cmp-under, but I don't think I need the plugin for this.
			-- I might add some more of my own.
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find("^_+")
				local _, entry2_under = entry2.completion_item.label:find("^_+")
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,

			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		["<c-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),
		["<M-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			{ "i", "c" }
		),

		["<c-space>"] = cmp.mapping({
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
			)
				if cmp.visible() then
					if not cmp.confirm({ select = true }) then
						return
					end
				else
					cmp.complete()
				end
			end,
		}),

		-- ["<tab>"] = false,
		["<tab>"] = cmp.config.disable,

		-- ["<tab>"] = cmp.mapping {
		--   i = cmp.config.disable,
		--   c = function(fallback)
		--     fallback()
		--   end,
		-- },

		-- Testing
		["<c-q>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),

		-- If you want tab completion :'(
		--  First you have to just promise to read `:help ins-completion`.
		--
		-- ["<Tab>"] = function(fallback)
		--   if cmp.visible() then
		--     cmp.select_next_item()
		--   else
		--     fallback()
		--   end
		-- end,
		-- ["<S-Tab>"] = function(fallback)
		--   if cmp.visible() then
		--     cmp.select_prev_item()
		--   else
		--     fallback()
		--   end
		-- end,
	},
	-- mapping = cmp.mapping.preset.insert({
	-- 	["<C-d>"] = cmp.mapping.scroll_docs(-4),
	-- 	["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 	["<C-Space>"] = cmp.mapping.complete({}),
	-- 	["<CR>"] = cmp.mapping.confirm({
	-- 		behavior = cmp.ConfirmBehavior.Replace,
	-- 		select = true,
	-- 	}),
	-- 	["<C-Tab>"] = cmp.mapping(function(fallback)
	-- 		if cmp.visible() then
	-- 			cmp.select_next_item()
	-- 		elseif luasnip.expand_or_jumpable() then
	-- 			luasnip.expand_or_jump()
	-- 		else
	-- 			fallback()
	-- 		end
	-- 	end, { "i", "s" }),
	-- 	["<S-Tab>"] = cmp.mapping(function(fallback)
	-- 		if cmp.visible() then
	-- 			cmp.select_prev_item()
	-- 		elseif luasnip.jumpable(-1) then
	-- 			luasnip.jump(-1)
	-- 		else
	-- 			fallback()
	-- 		end
	-- 	end, { "i", "s" }),
	-- }),
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "copilot" },
		{ name = "snippy" },
		{ name = "path" },
	},
	{
		{ name = "path" },
		{ name = "buffer", keyword_length = 5 },
	},
})

require("mason-null-ls").setup({
	ensure_installed = {
		"jsonlint",
		"tflint",
		"yamllint",
		"yamlfmt",
		"flake8",
		"mypy",
		"beautysh",
		"docformatter",
		"jsonlint",
		"shfmt",
		"sqlfluff",
		"hadolint",
		"stylua",
		"hadolint",
		"shfmt",
		"debugpy",
		"pyright",
	},
	automatic_setup = true,
})
local null_ls = require("null-ls")
vim.env.PATH = vim.env.PATH .. ":" .. "${HOME}/.pyenv/shims"
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.formatting.black,
		-- null_ls.builtins.formatting.isort,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.flake8.with({
			prefer_local = "$(whereis flake8)",
		}),
		null_ls.builtins.diagnostics.mypy.with({
			prefer_local = "$(whereis mypy)",
		}),
		-- null_ls.builtins.formatting.pyflyby.with({
		-- 	timeout = 5000,
		-- }),
		null_ls.builtins.formatting.beautysh,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.hadolint,
		null_ls.builtins.diagnostics.sqlfluff.with({
			extra_args = { "--dialect", "postgres" },
		}),
	},
})

require("nvim-autopairs").setup({})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local ts_utils = require("nvim-treesitter.ts_utils")

local ts_node_func_parens_disabled = {
	-- ecma
	named_imports = true,
	-- rust
	use_declaration = true,
}

local default_handler = cmp_autopairs.filetypes["*"]["("].handler
cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
	local node_type = ts_utils.get_node_at_cursor():type()
	if ts_node_func_parens_disabled[node_type] then
		if item.data then
			item.data.funcParensDisabled = true
		else
			char = ""
		end
	end
	default_handler(char, item, bufnr, rules, commit_character)
end

cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done({
		sh = false,
	})
)
