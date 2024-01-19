-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local gfs = require("gears.filesystem")
local ruled = require("ruled")
local awful = require("awful")

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
require("error-handling")

local sharedtags = require("awesome-sharetags")

require("deco.titlebar")
require("deco.notifications")
require("menu")

local bling = require("bling")
bling.module.flash_focus.enable()

awful.screen.connect_for_each_screen(function(s)  
  bling.module.tiled_wallpaper("O", s, {       
      fg = "#828da1", 
      bg = "#1b1f27", 
      offset_y = 20,  
      offset_x = 20,  
      font = "Sarasa Mono K Bold",   
      font_size = 8, 
      padding = 100,   
      zickzack = true  
  })
end)


-- local gitlab_contributions_widget =
-- 	require("awesome-wm-widgets.gitlab-contributions-widget.gitlab-contributions-widget")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- beautiful.font = "Fira Code Retina 8"
beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")
-- beautiful.gap_single_client = true
-- beautiful.useless_gap = 4

screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1
	for _, c in pairs(s.clients) do
		if only_one and not c.floating or c.maximized then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)
-- beautiful.bg_focus = "#b7bdf8"
-- beautiful.bg_normal = "#24273a"
-- beautiful.fg_focus = "#cad3f5"
-- beautiful.fg_normal = "#cad3f5"

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	-- bling.layout.mstab,
	-- bling.layout.centered,
	-- bling.layout.vertical,
	-- bling.layout.horizontal,
	-- bling.layout.equalarea,
	-- bling.layout.deck,
	-- awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

require("bar")
-- local tags = sharedtags({
-- 	{ name = "main", layout = awful.layout.layouts[1] },
-- 	{ name = "dev",  screen = 2,                      layout = awful.layout.layouts[1] },
-- 	{ name = "www",  screen = 2,                      layout = awful.layout.layouts[16] },
-- 	{ name = "misc", layout = awful.layout.layouts[1] },
-- 	{ name = "chat", screen = 1,                      layout = awful.layout.layouts[1] },
-- })
--
-- awful.screen.connect_for_each_screen(function(s)
-- 	-- Wallpaper
-- 	set_wallpaper(s)
--
-- 	-- -- Each screen has its own tag table.
-- 	-- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
--
-- 	-- Create a promptbox for each screen
-- 	s.mypromptbox = awful.widget.prompt()
-- 	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- 	-- We need one layoutbox per screen.
-- 	s.mylayoutbox = awful.widget.layoutbox(s)
-- 	s.mylayoutbox:buttons(gears.table.join(
-- 		awful.button({}, 1, function()
-- 			awful.layout.inc(1)
-- 		end),
-- 		awful.button({}, 3, function()
-- 			awful.layout.inc(-1)
-- 		end),
-- 		awful.button({}, 4, function()
-- 			awful.layout.inc(1)
-- 		end),
-- 		awful.button({}, 5, function()
-- 			awful.layout.inc(-1)
-- 		end)
-- 	))
-- 	-- Create a taglist widget
-- 	s.mytaglist = awful.widget.taglist({
-- 		screen = s,
-- 		filter = awful.widget.taglist.filter.all,
-- 		buttons = taglist_buttons,
-- 	})
--
-- 	-- Create a tasklist widget
-- 	s.mytasklist = awful.widget.tasklist({
-- 		screen = s,
-- 		filter = awful.widget.tasklist.filter.currenttags,
-- 		buttons = tasklist_buttons,
-- 	})
--
-- 	-- Create the wibox
-- 	s.mywibox = awful.wibar({ position = "top", screen = s })
--
-- 	-- Add widgets to the wibox
-- 	s.mywibox:setup({
-- 		layout = wibox.layout.align.horizontal,
-- 		{ -- Left widgets
-- 			layout = wibox.layout.fixed.horizontal,
-- 			mylauncher,
-- 			s.mytaglist,
-- 			spotify_widget({
-- 				play_icon = "/usr/share/icons/Papirus-Light/24x24/categories/spotify.svg",
-- 				pause_icon = "/usr/share/icons/Papirus-Dark/24x24/panel/spotify-indicator.svg",
-- 			}),
-- 		},
-- 		s.mytasklist, -- Middle widget
-- 		{ -- Right widgets
-- 			layout = wibox.layout.fixed.horizontal,
-- 			gitlab_widget({
-- 				timeout = 120
-- 			}),
-- 			cpu_widget(),
-- 			ram_widget(),
-- 			volume_widget({
-- 				widget_type = "arc",
-- 			}),
-- 			mykeyboardlayout,
-- 			wibox.widget.systray(),
-- 			mytextclock,
-- 			battery_widget(),
-- 			vpnwidget,
--
-- 			s.mylayoutbox,
-- 		},
-- 	})
-- end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}


-- {{{ Key bindings

awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    -- awful.key({ modkey, "Control" }, "r", awesome.restart,
    --           {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    --           {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
	awful.key({ modkey, "Control" }, "t", function()
		awful.spawn.with_shell("setxkbmap -layout br -variant thinkpad")
	end, { description = "set keyboardlayout to thinkpad", group = "launcher" }),
	awful.key({ modkey, "Control" }, "b", function()
		awful.spawn.with_shell("setxkbmap -layout us -variant intl")
	end, { description = "set keyboardlayout to brazil", group = "launcher" }),
	awful.key({ modkey, "Control" }, "e", function()
		awful.spawn.with_shell("setxkbmap -layout us")
	end, { description = "set keyboardlayout to english", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "b", function()
		awful.spawn.with_shell("xscreensaver-command -lock")
	end, { description = "lock screen", group = "launcher" }),
	awful.key({ modkey, "Control" }, "w", function()
		awful.spawn.with_shell("~/.config/i3/scripts/set-random-desktop-background")
	end, { description = "set random desktop background", group = "launcher" }),
	awful.key({ modkey, "Control" }, "d", function()
		awful.spawn.with_shell("~/.config/rofi/applets/music/music")
	end, { description = "spotify stuff", group = "launcher" }),
	awful.key({ modkey }, "d", function()
		awful.spawn.with_shell("~/.config/rofi/launchers/type-5/launcher.sh")
	end, { description = "dmenu", group = "launcher" }),
	awful.key({ modkey }, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "flameshot", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})
--
-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})

-- @DOC_NUMBER_KEYBINDINGS@

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

-- @DOC_CLIENT_BUTTONS@
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

-- @DOC_CLIENT_KEYBINDINGS@
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = tags[i]
				if tag then
					sharedtags.viewonly(tag, screen)
				end
			end,
			{ description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = tags[i]
				if tag then
					sharedtags.viewtoggle(tag, screen)
				end
			end,
			{ description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{ description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{ description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end
-- for i = 1, 9 do
-- 	globalkeys = gears.table.join(
-- 		globalkeys,
-- 		-- View tag only.
-- 		awful.key({ modkey }, "#" .. i + 9, function()
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[i]
-- 			if tag then
-- 				tag:view_only()
-- 			end
-- 		end, { description = "view tag #" .. i, group = "tag" }),
-- 		-- Toggle tag display.
-- 		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[i]
-- 			if tag then
-- 				awful.tag.viewtoggle(tag)
-- 			end
-- 		end, { description = "toggle tag #" .. i, group = "tag" }),
-- 		-- Move client to tag.
-- 		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
-- 			if client.focus then
-- 				local tag = client.focus.screen.tags[i]
-- 				if tag then
-- 					client.focus:move_to_tag(tag)
-- 				end
-- 			end
-- 		end, { description = "move focused client to tag #" .. i, group = "tag" }),
-- 		-- Toggle tag on focused client.
-- 		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
-- 			if client.focus then
-- 				local tag = client.focus.screen.tags[i]
-- 				if tag then
-- 					client.focus:toggle_tag(tag)
-- 				end
-- 			end
-- 		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
-- 	)
-- end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
-- root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
ruled.client.connect_signal("request::rules", function()
    -- @DOC_GLOBAL_RULE@
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- @DOC_FLOATING_RULE@
    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- @DOC_DIALOG_RULE@
    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        -- @DOC_CSD_TITLEBARS@
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)
-- }}}

awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = true },
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
	{ rule = { class = "google-chrome" },
		   properties = { tag = "www" } },
	{ rule = { class = "kitty" },
		   properties = { tag = "dev" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears

client.connect_signal("manage", function(c)
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
	c.shape = function(cr,w,h)
	    gears.shape.rounded_rect(cr,w,h,10)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

-- naughty.connect_signal("request::display", function(n)
--     naughty.layout.box { notification = n }
-- end)

-- }}}

-- Spawn applications
awful.spawn.with_shell("~/.config/awesome/scripts/autostart.sh")
awful.spawn("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 --exit-with-session awesome")
awful.spawn("nm-applet")
awful.spawn.with_shell("picom --config ~/.config/picom.conf")
-- awful.spawn.with_shell("autorandr --load default")
awful.spawn.with_shell("xscreensaver -no-splash")
-- awful.spawn.with_shell("~/.config/i3/scripts/set-random-desktop-background")
-- ... Add more startup applications
-- }}}
