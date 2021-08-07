local wibox = require("wibox")
require("awful.autofocus")
local utils = require("utils")
local kb_layout_widget = require("./widgets/kb_layout_widget")
local volume_widget = require("./widgets/volume_widget")
local battery_widget = require("./widgets/battery_widget")
local time_date_widget = require("./widgets/time_date_widget")
local util_scripts = require("util_scripts")
local theme = require("theme")

local space = " "
local widgets = {}

widgets.keyboard_layout = kb_layout_widget.basic
widgets.volume = volume_widget.basic
widgets.battery = battery_widget.basic
widgets.time_date = time_date_widget.basic

local function get_printable_speed(number)

    local units = {" B", "KB", "MB", "GB"}
    local counter = 1

    while number >= 100 do
        number = number / 1024
        counter = counter + 1
    end

    local strNum = tostring(utils.round(number, 2))
    local splits = utils.split(strNum, ".")

    if string.len(splits[2]) == 1 then splits[2] = splits[2] .. "0" end

    splits[1] = utils.ensure_length(splits[1], 2)

    return splits[1] .. "." .. splits[2] .. " " .. units[counter] .. "/s"

end

local function set_active_conn_container(container, wired, rx, tx)

    if not wired then
        container.widget.children[1].text = space .. "直" .. space
    else
        container.widget.children[1].text = space .. "" .. space
    end

    rx = utils.bold_markup(get_printable_speed(rx))
    tx = utils.bold_markup(get_printable_speed(tx))

    container.widget.children[2].markup = space .. " " .. rx .. space
    container.widget.children[3].markup = space .. " " .. tx .. space

end

local function set_discon_conn_container(container, wired)

    if not wired then
        container.widget.children[1].text = space .. "睊" .. space
    else
        container.widget.children[1].text = space .. "" .. space
    end

    container.widget.children[2].markup =
        space .. utils.bold_markup("0.0 B") .. space
    container.widget.children[3].markup =
        space .. utils.bold_markup("0.0 B") .. space

end

local function manage_device(device, timer, container, wired)

    local currentRx = 0
    local currentTx = 0

    timer:connect_signal("timeout", function()
        util_scripts.conn_active(device, function(connected)
            if connected then
                util_scripts.get_conn_bytes(device, function(new_rx, new_tx)
                    local rx = (new_rx - currentRx) / 5
                    local tx = (new_tx - currentTx) / 5

                    set_active_conn_container(container, wired, rx, tx)

                    currentRx = new_rx
                    currentTx = new_tx
                end)
            else
                -- set_discon_conn_container(container, wired)
            end
        end)
    end)
end

local function manage_adapters_list(list, widgets_table, timer, wired)
    for _, value in ipairs(list) do
        local container = wibox.container.background()

        container.widget = wibox.widget {
            layout = wibox.layout.align.horizontal,
            {widget = wibox.widget.textbox, font = theme.font},
            {widget = wibox.widget.textbox, font = theme.font},
            {widget = wibox.widget.textbox, font = theme.font}
        }

        manage_device(value, timer, container, wired)
        table.insert(widgets_table, container)
    end
end

function widgets.connection(wiredList, wifiList)

    local connection_widget = {}
    local wired_widgets_table = {layout = wibox.layout.align.horizontal}
    local wifi_widgets_table = {layout = wibox.layout.align.horizontal}

    local timer = timer({timeout = 5})

    manage_adapters_list(wiredList, wired_widgets_table, timer, true)
    manage_adapters_list(wifiList, wifi_widgets_table, timer, false)

    connection_widget.widget = wibox.widget {
        wired_widgets_table,
        wifi_widgets_table,
        layout = wibox.layout.align.horizontal
    }

    timer:start()

    return connection_widget
end

return widgets
