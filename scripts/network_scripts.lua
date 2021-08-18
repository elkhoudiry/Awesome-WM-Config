local awful = require("awful")
local common = require("../utils/common")

local network_scripts = {}

function network_scripts.check_connected(device, callback)
    local cmd = "nmcli device show " .. device .. " | awk '/STATE/{print $2}'"

    awful.spawn.easy_async_with_shell(cmd, function(result)
        if tonumber(result) == 100 then
            network_scripts.get_connection_bytes(device, function(rx, tx)
                callback(true, rx, tx)
            end)
        else
            callback(false)
        end
    end)

end

function network_scripts.get_connection_bytes(device, callback)

    local rx_cmd = "cat /sys/class/net/" .. device .. "/statistics/rx_bytes"
    local tx_cmd = "cat /sys/class/net/" .. device .. "/statistics/tx_bytes"

    awful.spawn.easy_async_with_shell(rx_cmd, function(rx)
        awful.spawn.easy_async_with_shell(tx_cmd, function(tx)
            callback(tonumber(rx), tonumber(tx))
        end)
    end)

end

return network_scripts
