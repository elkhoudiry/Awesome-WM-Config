local wibox = require("wibox")
local common = require("../utils/common")
local network_scripts = require("../scripts/network_scripts")
local theme = require("../theme")
local space = common.txt_space

local network_widget = {}
network_widget.sleep = 1

local function get_printable_speed(number)

    local units = {" B", "KB", "MB", "GB"}
    local counter = 1

    while number >= 100 do
        number = number / 1024
        counter = counter + 1
    end

    local strNum = tostring(common.round(number, 2))
    local splits = common.split(strNum, ".")

    if string.len(splits[2]) == 1 then splits[2] = splits[2] .. "0" end

    splits[1] = common.ensure_length(splits[1], 2)

    return splits[1] .. "." .. splits[2] .. " " .. units[counter] .. "/s"

end

local function set_active_conn_container(container, wired, rx, tx)

    if not wired then
        container.widget.children[1].text = space .. "直" .. space
    else
        container.widget.children[1].text = space .. "" .. space
    end

    if not container.activate then
        container.widget.children[2].visible = true
        container.widget.children[3].visible = true
        container.activate = true
    end

    rx = common.bold_markup(get_printable_speed(rx))
    tx = common.bold_markup(get_printable_speed(tx))

    container.widget.children[2].markup = space .. rx .. space
    container.widget.children[3].markup = space .. tx .. space

end

local function set_discon_conn_container(container, wired)

    if not wired then
        container.widget.children[1].text = space .. "睊" .. space
    else
        container.widget.children[1].text = space .. "" .. space
    end

    if container.active then
        container.widget.children[2].visible = false
        container.widget.children[3].visible = false
        container.active = false
    end

    -- container.widget.children[2].markup =
    --     space .. common.bold_markup("0.0 B") .. space
    -- container.widget.children[3].markup =
    --     space .. common.bold_markup("0.0 B") .. space

end

local function manage_device(device, timer, callback)

    local currentRx = 0
    local currentTx = 0

    callback(false, 0, 0)

    timer:connect_signal("timeout", function()
        network_scripts.check_connected(device, function(connected)
            if connected then
                network_scripts.get_connection_bytes(device, function(nrx, ntx)
                    local rx = (nrx - currentRx) / network_widget.sleep
                    local tx = (ntx - currentTx) / network_widget.sleep

                    currentRx = nrx
                    currentTx = ntx

                    callback(connected, rx, tx)
                end)
            else
                callback(connected)
            end
        end)
    end)
end

local function manage_devices(list, table, timer, wired)
    for i, value in ipairs(list) do --
        manage_device(value, timer, function(connected, rx, tx) --
            local container = table[i]
            if connected then
                set_active_conn_container(container, wired, rx, tx)
            else
                set_discon_conn_container(container, wired)
            end
        end)
    end
end

local function init_widget_table(list)
    local t = {layout = wibox.layout.align.horizontal}
    for _, _ in ipairs(list) do
        local container = wibox.container.background()

        container.widget = wibox.widget {
            layout = wibox.layout.align.horizontal,
            {widget = wibox.widget.textbox, font = theme.font},
            {widget = wibox.widget.textbox, font = theme.font},
            {widget = wibox.widget.textbox, font = theme.font}
        }
        container.active = true
        table.insert(t, container)
    end

    return t
end

function network_widget.basic(wiredList, wifiList)

    local connection_widget = {}

    -- table >> containers >> widgets
    local wired_widgets_table = init_widget_table(wiredList)
    local wifi_widgets_table = init_widget_table(wifiList)

    local timer = timer({timeout = network_widget.sleep})
    timer:start()

    manage_devices(wiredList, wired_widgets_table, timer, true)
    manage_devices(wifiList, wifi_widgets_table, timer, false)

    connection_widget.widget = wibox.widget {
        wired_widgets_table,
        wifi_widgets_table,
        layout = wibox.layout.align.horizontal
    }

    return connection_widget
end

return network_widget
