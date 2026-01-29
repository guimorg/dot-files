local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action
local keys = {}
local mouse_bindings = {}
local launch_menu = {}
local home = os.getenv("HOME")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local wezterm_session_manager = require("wezterm-session-manager/session-manager")

local sessionizer_loaded, sessionizer = pcall(require, "sessionizer")
if not sessionizer_loaded then
	wezterm.log_error("Failed to load sessionizer: " .. tostring(sessionizer))
	sessionizer = nil
else
	sessionizer.setup({
		paths = { home .. "/projects" },
		zoxide_path = "/run/current-system/sw/bin/zoxide",
		fd_path = "/opt/homebrew/bin/fd",
		depth = 6,
	})
end

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
		action = act.SpawnCommandInNewTab {
			args = { "/bin/zsh", "-l", "-c", home .. "/.local/bin/workspace-picker-wrapper.sh" },
		},
	},
	{
		key = "w",
		mods = "CMD",
		action = sessionizer.manage_workspaces(),
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


-- Session Manager
wezterm.on("save_session", function(window) wezterm_session_manager.save_state(window) end)
wezterm.on("load_session", function(window) wezterm_session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) wezterm_session_manager.restore_state(window) end)

-- Workspace picker handler
wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "WORKSPACE_SELECTED" and value ~= "" then
		local selected_dir = value
		local workspace_name = selected_dir:match("^.*/(.+)$") or selected_dir
		
		local logfile = io.open("/tmp/wezterm-lua-handler.log", "a")
		logfile:write(os.date("%Y-%m-%d %H:%M:%S") .. " - WORKSPACE_SELECTED received\n")
		logfile:write("  value: " .. value .. "\n")
		logfile:write("  workspace_name: " .. workspace_name .. "\n")
		logfile:close()
		
		wezterm.log_info("Switching to workspace: " .. workspace_name)
		
		local exists = false
		for _, ws in ipairs(mux.get_workspace_names()) do
			if ws == workspace_name then
				exists = true
				break
			end
		end
		
		if exists then
			window:perform_action(act.SwitchToWorkspace({ name = workspace_name }), pane)
		else
			window:perform_action(
				act.SwitchToWorkspace({
					name = workspace_name,
					spawn = { cwd = selected_dir }
				}),
				pane
			)
		end
		
		wezterm.sleep_ms(100)
		pane:send_text("exit\n")
	end
	
	if name == "WORKSPACE_SWITCH" and value ~= "" then
		local workspace_name = value
		wezterm.log_info("Switching to workspace from manager: " .. workspace_name)
		window:perform_action(act.SwitchToWorkspace({ name = workspace_name }), pane)
		wezterm.sleep_ms(100)
		pane:send_text("exit\n")
	end
	
	if name == "WORKSPACE_DELETE" and value ~= "" then
		local workspace_name = value
		wezterm.log_info("Deleting workspace: " .. workspace_name)
		
		local panes_to_kill = {}
		for _, win in ipairs(mux.all_windows()) do
			if win:get_workspace() == workspace_name then
				for _, tab in ipairs(win:tabs()) do
					for _, p in ipairs(tab:panes()) do
						table.insert(panes_to_kill, p:pane_id())
					end
				end
			end
		end
		
		for _, pane_id in ipairs(panes_to_kill) do
			wezterm.run_child_process({"/opt/homebrew/bin/wezterm", "cli", "kill-pane", "--pane-id", tostring(pane_id)})
		end
		
		wezterm.sleep_ms(100)
		pane:send_text("exit\n")
	end
end)

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
