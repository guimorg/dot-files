local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action
local keys = {}
local mouse_bindings = {}
local launch_menu = {}
local smart_workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local wezterm_session_manager = require("wezterm-session-manager/session-manager")

local home = os.getenv("HOME")

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
	{
		key = "p",
		mods = "CMD",
		action = act.ShowLauncherArgs { flags = "FUZZY|TABS" }
	},
	{
		key = "o",
		mods = "CMD",
		action = smart_workspace_switcher.switch_workspace()
	},
	{
		key = "O",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab {
			args = { "/bin/zsh", "-l", "-c", home .. "/.local/bin/wezterm-zoxide-workspace" },
		},
	},
	{
		key = "S",
		mods = "LEADER",
		action = wezterm.action { EmitEvent = "save_session" }
	},
	{
		key = "L",
		mods = "LEADER",
		action = wezterm.action { EmitEvent = "load_session" }
	},
	{
		key = "R",
		mods = "LEADER",
		action = wezterm.action { EmitEvent = "restore_session" }
	},
}

-- Plugins
smart_workspace_switcher.apply_to_config(config)

-- Session Manager
wezterm.on("save_session", function(window) wezterm_session_manager.save_state(window) end)
wezterm.on("load_session", function(window) wezterm_session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) wezterm_session_manager.restore_state(window) end)

-- Tabline
tabline.setup({
  options = {
    theme = 'Catppuccin Mocha',
  },
})
tabline.apply_to_config(config)

-- Rename
wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local title = pane.current_working_dir and pane.current_working_dir.file_path or pane.title
  return { { Text = ' ' .. title .. ' ' } }
end)

return config
