local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- General settings
config.font_size = 16
config.line_height = 1.2
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.color_scheme = "Catppuccin Mocha"
config.cursor_blink_rate = 800
config.cursor_thickness = "2 px"
config.window_background_opacity = 0.85
config.default_prog = { "/bin/zsh" }
config.use_dead_keys = false

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

config.window_decorations = 'RESIZE'
config.enable_tab_bar = false

-- Keybindings
config.keys = {
	{
		key = 'w',
		mods = 'CMD',
		action = act.CloseCurrentPane { confirm = false }
	},
	{
		key = 'd',
		mods = 'CMD',
		action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
	},
	{
		key = 'd',
		mods = 'CMD|SHIFT',
		action = act.SplitVertical { domain = 'CurrentPaneDomain' }
	},
	{
		key = 'C',
		mods = 'SHIFT|CTRL',
		action = act.CopyTo 'Clipboard'
	},
	{
		key = 'v',
		mods = 'CMD',
		action = act.PasteFrom 'Clipboard'
	},
}

return config
