local awful = require("awful")

local battery_scripts = {}

function battery_scripts.get_basic_battery(callback)
    -- Battery Status
    local status_cmd = "cat /sys/class/power_supply/BAT0/status"
    local capacity_cmd = "cat /sys/class/power_supply/BAT0/capacity"

    awful.spawn.easy_async_with_shell(status_cmd, function(status) -- 
        awful.spawn.easy_async_with_shell(capacity_cmd, function(capacity)
            local capacityNum = tonumber(capacity)

            if string.find(status, "Unkn") ~= nil then
                callback("", tostring(capacityNum))
            elseif string.find(status, "Charging") ~= nil then
                callback("", tostring(capacityNum))
            elseif capacityNum >= 5 and capacityNum <= 19 then
                callback("", tostring(capacityNum))
            elseif capacityNum >= 20 and capacityNum <= 39 then
                callback("", tostring(capacityNum))
            elseif capacityNum >= 40 and capacityNum <= 59 then
                callback("", tostring(capacityNum))
            elseif capacityNum >= 60 and capacityNum <= 79 then
                callback("", tostring(capacityNum))
            elseif capacityNum >= 80 and capacityNum <= 95 then
                callback("", tostring(capacityNum))
            elseif capacityNum < 96 and capacityNum <= 100 then
                callback("", tostring(capacityNum))
            end

        end)
    end)
end

return battery_scripts
