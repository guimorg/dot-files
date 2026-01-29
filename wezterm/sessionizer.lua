local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local M = {}
local config = {
	paths = {},
	zoxide_path = "zoxide",
	fd_path = "fd",
	depth = 6,
}

function M.setup(opts)
	if opts then
		for k, v in pairs(opts) do
			config[k] = v
		end
	end
end

local function get_active_workspaces()
	local active = {}
	for _, ws_name in ipairs(mux.get_workspace_names()) do
		active[ws_name] = true
	end
	return active
end

local function get_directories()
	local cmd = string.format(
		"(%s query -l 2>/dev/null || true; %s -H -t d '^.git$' %s -d %d 2>/dev/null | xargs -I{} dirname '{}') | awk '!seen[$0]++'",
		config.zoxide_path,
		config.fd_path,
		table.concat(config.paths, " "),
		config.depth
	)

	local success, stdout, stderr = wezterm.run_child_process({
		"/bin/zsh",
		"-l",
		"-c",
		cmd,
	})

	if not success then
		wezterm.log_error("Failed to get directories: " .. stderr)
		return {}
	end

	local dirs = {}
	for line in stdout:gmatch("[^\r\n]+") do
		if line ~= "" then
			table.insert(dirs, line)
		end
	end

	return dirs
end

local function format_choice(path, is_active, basename)
	local display_path = path:gsub("^" .. os.getenv("HOME"), "~")

	local icon = is_active and "✓" or "󰉋"
	local icon_color = is_active and "#a6e3a1" or "#89b4fa"

	local formatted_label = wezterm.format({
		{ Foreground = { Color = icon_color } },
		{ Text = icon .. " " },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = basename },
		"ResetAttributes",
		{ Foreground = { Color = "#6c7086" } },
		{ Text = "  " .. display_path },
	})

	return {
		id = path,
		label = formatted_label,
	}
end

function M.manage_workspaces()
	return wezterm.action_callback(function(window, pane)
		local workspace_data = {}
		local current_ws = window:active_workspace()
		
		local all_windows = mux.all_windows()
		wezterm.log_info("Found " .. #all_windows .. " windows")
		
		for _, win in ipairs(all_windows) do
			local ws_name = win:get_workspace()
			wezterm.log_info("Window workspace: " .. ws_name)
			
			if not workspace_data[ws_name] then
				workspace_data[ws_name] = {
					name = ws_name,
					panes = 0,
					cwd = "~"
				}
			end
			
			for _, tab in ipairs(win:tabs()) do
				local panes_list = tab:panes()
				workspace_data[ws_name].panes = workspace_data[ws_name].panes + #panes_list
				
				if workspace_data[ws_name].cwd == "~" and #panes_list > 0 then
					local cwd_uri = panes_list[1]:get_current_working_dir()
					if cwd_uri then
						workspace_data[ws_name].cwd = cwd_uri.file_path
					end
				end
			end
		end
		
		for ws, data in pairs(workspace_data) do
			wezterm.log_info("Workspace: " .. ws .. " with " .. data.panes .. " panes")
		end
		
		local lines = {}
		for _, info in pairs(workspace_data) do
			local marker = (info.name == current_ws) and "CURRENT" or "INACTIVE"
			local line = string.format("%s|%s|%d|%s\n", info.name, marker, info.panes, info.cwd)
			table.insert(lines, line)
		end
		
		local tempfile = "/tmp/wezterm-workspaces-" .. tostring(os.time()) .. ".txt"
		local f = io.open(tempfile, "w")
		if f then
			for _, line in ipairs(lines) do
				f:write(line)
			end
			f:close()
		end
		
		window:perform_action(act.SpawnCommandInNewTab({
			args = {"/bin/zsh", "-l", "-c", 
				os.getenv("HOME") .. "/.local/bin/workspace-manager-display.sh " .. tempfile}
		}), pane)
	end)
end

function M.switch_workspace_action(window, pane)
		local active_workspaces = get_active_workspaces()
		local directories = get_directories()

		if #directories == 0 then
			wezterm.log_error("No directories found")
			return
		end

		local choices = {}
		local choice_data = {}
		for _, dir in ipairs(directories) do
			local basename = dir:match("^.*/(.+)$") or dir
			local is_active = active_workspaces[basename] == true
			table.insert(choice_data, {
				path = dir,
				basename = basename,
				is_active = is_active,
			})
		end

		table.sort(choice_data, function(a, b)
			if a.is_active ~= b.is_active then
				return a.is_active
			end
			return a.basename < b.basename
		end)

		for _, data in ipairs(choice_data) do
			table.insert(choices, format_choice(data.path, data.is_active, data.basename))
		end

		window:perform_action(
			act.InputSelector({
				action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
					if not id then
						return
					end

					local workspace_name = id:match("^.*/(.+)$") or id

					for _, ws in ipairs(mux.get_workspace_names()) do
						if ws == workspace_name then
							inner_window:perform_action(act.SwitchToWorkspace({ name = workspace_name }), inner_pane)
							return
						end
					end

					inner_window:perform_action(
						act.SwitchToWorkspace({
							name = workspace_name,
							spawn = { cwd = id },
						}),
						inner_pane
					)
				end),
				title = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { Color = "#cba6f7" } },
					{ Text = "󰉋 Select Workspace" },
				}),
				choices = choices,
				fuzzy = true,
				description = wezterm.format({
					{ Foreground = { Color = "#6c7086" } },
					{ Text = "Type to filter, Enter to select, Esc to cancel" },
				}),
			}),
			pane
		)
end

return M
