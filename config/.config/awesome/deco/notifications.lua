local color = require("popups.color")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

naughty.config.defaults.ontop = true
-- naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 10
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = dpi(16)

naughty.config.icon_dirs = {
    "/usr/share/icons/Papirus-Dark/24x24/apps/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}

-- Timeouts
naughty.config.presets.low.timeout = 10
naughty.config.presets.critical.timeout = 0

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

-- Variables
-- Function to find an icon for a given app name
local function find_icon_for_app(app_name)
    local icon_dirs = naughty.config.icon_dirs
    local icon_formats = naughty.config.icon_formats
    for _, dir in ipairs(icon_dirs) do
        for _, format in ipairs(icon_formats) do
            local icon_path = dir .. app_name:lower() .. "." .. format
            if gears.filesystem.file_readable(icon_path) then
                return icon_path
            end
        end
    end
    return beautiful.awesome_icon
end

local max_chars = 240

-- Function to truncate a string to a specified length
local function truncate_string(str, max_len)
    if string.len(str) > max_len then
        return string.sub(str, 1, max_len) .. "..."
    else
        return str
    end
end


naughty.connect_signal("request::display", function(n)
    n.timeout = 10

    local appicon = find_icon_for_app(n.app_name)
    local truncated_message = truncate_string(n.message, max_chars)

    local action_widget = {
        {
            {
                id = 'text_role',
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin
        },
        widget = wibox.container.background
    }

    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style = {underline_normal = false, underline_selected = true},
        widget = naughty.list.actions
    }

    naughty.layout.box {
        notification = n,
        type = "notification",
	bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            image = appicon,
                                            resize = true,
                                            clip_shape = gears.shape.rounded_rect,
                                            widget = wibox.widget.imagebox
                                        },
                                        strategy = "max",
                                        height = dpi(20),
                                        widget = wibox.container.constraint
                                    },
                                    right = dpi(10),
                                    widget = wibox.container.margin
                                },
                                {
                                    markup = n.app_name,
                                    align = "left",
                                    font = beautiful.font,
                                    widget = wibox.widget.textbox
                                },
                                {
                                    markup = time,
                                    align = "right",
                                    font = beautiful.font,
                                    widget = wibox.widget.textbox
                                },
                                layout = wibox.layout.align.horizontal
                            },
                            top = dpi(20),
                            left = dpi(20),
                            right = dpi(20),
                            bottom = dpi(10),
                            widget = wibox.container.margin
                        },
                        widget = wibox.container.background
                    },
                    {
                        {
                            {
                                helpers.vertical_pad(10),
                                {
                                    {
                                        step_function = wibox.container.scroll
                                            .step_functions
                                            .waiting_nonlinear_back_and_forth,
                                        speed = 50,
                                        {
                                            markup = "<span weight='bold'>" ..
                                                n.title .. "</span>",
                                            font = beautiful.font,
                                            align = "left",
                                            widget = wibox.widget.textbox
                                        },
                                        forced_width = dpi(250),
                                        widget = wibox.container.scroll
                                            .horizontal
                                    },
                                    {
                                        {
                                            markup = truncated_message,
                                            align = "left",
                                            font = beautiful.font,
                                            wrap = "word",
                                            widget = wibox.widget.textbox
                                        },
                                        right = 10,
                                        strategy = "max",
                                        width = dpi(300),
                                        height = dpi(100),
                                        widget = wibox.container.constraint
                                    },
                                    spacing = 0,
                                    layout = wibox.layout.flex.vertical
                                },
                                helpers.vertical_pad(10),
                                layout = wibox.layout.align.vertical
                            },
                            left = dpi(20),
                            right = dpi(20),
                            widget = wibox.container.margin
                        },
                        {
                            {
                                nil,
                                {
                                    {
                                        image = n.icon,
                                        resize = true,
					clip_shape = gears.shape.rounded_rect,
                                        widget = wibox.widget.imagebox
                                    },
                                    strategy = "max",
                                    height = 40,
                                    widget = wibox.container.constraint
                                },
                                nil,
                                expand = "none",
                                layout = wibox.layout.align.vertical
                            },
                            top = dpi(0),
                            left = dpi(10),
                            right = dpi(10),
                            bottom = dpi(0),
                            widget = wibox.container.margin
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        {actions, layout = wibox.layout.fixed.vertical},
                        margins = dpi(10),
                        visible = n.actions and #n.actions > 0,
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.vertical
                },
                top = dpi(0),
                bottom = dpi(5),
                widget = wibox.container.margin
            },
  	    bg = color.background_lighter,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background
        }
    }
end)
