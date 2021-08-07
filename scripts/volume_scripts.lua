local awful = require("awful")
local common = require("../utils/common")

local volume_scripts = {}

function volume_scripts.get_basic_volume(callback)
    volume_scripts.get_volume_level(function(volume)
        awful.spawn.easy_async_with_shell("pamixer --get-mute", function(mute)
            local volNum = tonumber(volume)
            if string.find(mute, "true") ~= nil then
                callback("", common.ensure_length(tostring(volNum), 3))
            elseif volNum > 70 and volNum <= 100 then
                callback("", common.ensure_length(tostring(volNum), 3))
            elseif volNum > 100 then
                callback("ﰝ", common.ensure_length(tostring(volNum), 3))
            elseif volNum < 30 then
                callback("", common.ensure_length(tostring(volNum), 3))
            elseif volNum == 0 then
                callback("", common.ensure_length(tostring(volNum), 3))
            else
                callback("墳", common.ensure_length(tostring(volNum), 3))
            end
        end)
    end)
end

function volume_scripts.toggle_mute(timer)
    awful.spawn.easy_async_with_shell("pamixer -t", function()
        timer:emit_signal("timeout")
    end)
end

function volume_scripts.get_volume_level(callback)
    awful.spawn.easy_async_with_shell("pamixer --get-volume", function(volume)
        --
        callback(volume)
    end)
end

function volume_scripts.set_volume_level(value, widget)
    local cmd = "pamixer  --allow-boost --set-volume " .. value

    awful.spawn.easy_async_with_shell(cmd, function()
        widget:emit_signal("volumechanged")
    end)
end

return volume_scripts
