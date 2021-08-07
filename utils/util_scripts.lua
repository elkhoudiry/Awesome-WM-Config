local awful = require("awful")
local utils = require("utils")

local util_scripts = {}

function util_scripts.battery(callback)
    -- Battery Status
    awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/status",
                                      function(status)
        -- Battery Capacity
        awful.spawn.easy_async_with_shell(
            "cat /sys/class/power_supply/BAT0/capacity", function(capacity)
                local capacityNum = tonumber(capacity)
                local icon = ""

                if string.find(status, "Unkn") ~= nil then
                    icon = ""
                elseif string.find(status, "Charging") ~= nil then
                    icon = ""
                elseif capacityNum >= 5 and capacityNum <= 19 then
                    icon = ""
                elseif capacityNum >= 20 and capacityNum <= 39 then
                    icon = ""
                elseif capacityNum >= 40 and capacityNum <= 59 then
                    icon = ""
                elseif capacityNum >= 60 and capacityNum <= 79 then
                    icon = ""
                elseif capacityNum >= 80 and capacityNum <= 95 then
                    icon = ""
                elseif capacityNum < 96 and capacityNum <= 100 then
                    icon = ""
                end

                callback(icon, tostring(capacityNum))

            end)
    end)

end

function util_scripts.conn_active(device, callback)

    local cmd = "nmcli device show " .. device .. " | awk '/STATE/{print $2}'"

    awful.spawn.easy_async_with_shell(cmd, function(result)
        if tonumber(result) == 100 then
            callback(true)
        else
            callback(false)
        end
    end)

end

function util_scripts.get_conn_bytes(device, callback)

    local rx_cmd = "cat /sys/class/net/" .. device .. "/statistics/rx_bytes"
    local tx_cmd = "cat /sys/class/net/" .. device .. "/statistics/tx_bytes"

    awful.spawn.easy_async_with_shell(rx_cmd, function(rx)
        awful.spawn.easy_async_with_shell(tx_cmd, function(tx)
            callback(tonumber(rx), tonumber(tx))
        end)
    end)

end

function util_scripts.volume(callback)
    util_scripts.get_volume_level(function(volume)
        awful.spawn.easy_async_with_shell("pamixer --get-mute", function(mute)
            local volNum = tonumber(volume)
            if string.find(mute, "true") ~= nil then
                callback("", utils.ensure_length(tostring(volNum), 3))
            elseif volNum > 70 and volNum <= 100 then
                callback("", utils.ensure_length(tostring(volNum), 3))
            elseif volNum > 100 then
                callback("ﰝ", utils.ensure_length(tostring(volNum), 3))
            elseif volNum < 30 then
                callback("", utils.ensure_length(tostring(volNum), 3))
            elseif volNum == 0 then
                callback("", utils.ensure_length(tostring(volNum), 3))
            else
                callback("墳", utils.ensure_length(tostring(volNum), 3))
            end
        end)
    end)
end

function util_scripts.toggle_mute(timer)
    awful.spawn.easy_async_with_shell("pamixer -t", function()
        timer:emit_signal("timeout")
    end)
end

function util_scripts.get_volume_level(callback)
    awful.spawn.easy_async_with_shell("pamixer --get-volume", function(volume)
        --
        callback(volume)
    end)
end

function util_scripts.set_volume_level(value, timer)
    local cmd = "pamixer  --allow-boost --set-volume " .. value

    awful.spawn.easy_async_with_shell(cmd, function()
        timer:emit_signal("timeout")
    end)
end
return util_scripts
