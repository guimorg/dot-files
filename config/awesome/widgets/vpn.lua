local wibox = require("wibox")

local vpnwidget = wibox.widget.textbox()
vpnwidget:set_text("  ")
local vpnwidgettimer = timer({ timeout = 5 })
vpnwidgettimer:connect_signal("timeout", function()
	local status = io.popen("pgrep openconnect", "r")
	if status:read() == nil then
		vpnwidget:set_markup(" <span color='#FFFC00'></span> ")
	else
		vpnwidget:set_markup(" <span color='#FF0000'></span> ")
	end
	status:close()
end)
vpnwidgettimer:start()
return vpnwidget
