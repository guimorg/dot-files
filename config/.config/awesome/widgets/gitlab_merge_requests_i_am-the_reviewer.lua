local wibox = require("wibox")

local mergeRequestsWidget = wibox.widget.textbox()
mergeRequestsWidget:set_markup("<span color='bc0303'>   ?  </span>")

local mergeRequestsTimer = timer({ timeout = 60 })
mergeRequestsTimer:connect_signal("timeout", function()
    local handle = io.popen("/home/guimorg/.asdf/shims/glab api '/merge_requests?scope=all&state=opened&reviewer_username=guilherme.amorim' | jq 'length' | grep -E '^[0-9]+$'", "r")
    if handle == nil then
        mergeRequestsWidget:set_markup("<span color='#FF0000'>error</span> ")
        return
    end
    local result = handle:read("*a")
    local _, _, exitStatus = handle:close()
    if exitStatus ~= 0 then
        return
    end
    mergeRequestsWidget:set_markup("<span color='#f08c05'>   " .. result .. " MRs</span> ")
end)
mergeRequestsTimer:start()

return mergeRequestsWidget
