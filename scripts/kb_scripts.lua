local awful = require("awful")
local common = require("../utils/common")

local kb_scripts = {}

function kb_scripts.set_kb_layout(layout, callback)
    local cmd = "setxkbmap " .. layout
    awful.spawn.easy_async(cmd, function() callback() end)
end

return kb_scripts
