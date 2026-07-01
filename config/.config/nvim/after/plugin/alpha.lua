local present, alpha = pcall(require, "alpha")
if not present then
	return
end

local dashboard = require("alpha.themes.dashboard")

local datetime = os.date("%H:%M")
local date = os.date("%A, %B %d, %Y")

dashboard.section.header.val = {
	"",
	"",
	"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
	"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
	"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
	"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
	"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
	"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
	"",
}

dashboard.section.header.opts = {
	position = "center",
	hl = "DashboardHeader",
}

local hi_top_section = {
	type = "text",
	val = "󰃭 " .. date .. "  " .. datetime,
	opts = {
		position = "center",
		hl = "DashboardDate",
	},
}

local leader = "SPC"

local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "center",
		shortcut = "[" .. sc .. "]",
		cursor = 3,
		width = 50,
		align_shortcut = "right",
		hl_shortcut = "DashboardShortcut",
		hl = "DashboardFg",
	}

	if keybind then
		keybind_opts = keybind_opts or { noremap = true, silent = true, nowait = true }
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

dashboard.section.buttons.val = {
	button("SPC p p", "  Find Project", "<cmd>Telescope find_files<CR>", {}),
	button("SPC f f", "  Find File", "<cmd>Telescope find_files<CR>", {}),
	button("SPC f r", "  Recent Files", "<cmd>Telescope oldfiles<CR>", {}),
	button("SPC s p", "  Search Project", "<cmd>Telescope live_grep<CR>", {}),
	button("SPC / u", "  Update Plugins", "<cmd>Lazy update<CR>", {}),
	button("q", "󰿅  Quit", "<cmd>qa<CR>", {}),
}

local function footer()
	local total_plugins = require("lazy").stats().count
	local v = vim.version()
	local version = string.format("v%d.%d.%d", v.major, v.minor, v.patch)
	return "⚡ Neovim " .. version .. "  │  󰂖 " .. total_plugins .. " plugins"
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts = {
	position = "center",
	hl = "DashboardFooter",
}

alpha.setup({
	layout = {
		{ type = "padding", val = 2 },
		dashboard.section.header,
		{ type = "padding", val = 1 },
		hi_top_section,
		{ type = "padding", val = 2 },
		dashboard.section.buttons,
		{ type = "padding", val = 1 },
		dashboard.section.footer,
	},
	opts = { margin = 5 },
})

vim.api.nvim_create_augroup("alpha_tabline", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = "alpha_tabline",
	pattern = "alpha",
	command = "set showtabline=0 laststatus=0 noruler",
})

vim.api.nvim_create_autocmd("FileType", {
	group = "alpha_tabline",
	pattern = "alpha",
	callback = function()
		vim.api.nvim_create_autocmd("BufUnload", {
			group = "alpha_tabline",
			buffer = 0,
			command = "set showtabline=2 ruler laststatus=3",
		})
	end,
})
