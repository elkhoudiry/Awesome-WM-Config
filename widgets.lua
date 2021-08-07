local wibox = require("wibox")
require("awful.autofocus")
local utils = require("utils")
local kb_layout = require("./widgets/kb_layout_widget")
local util_scripts = require("util_scripts")
local theme = require("theme")

local space = " "
local widgets = {}

widgets.keyboard_layout = kb_layout.basic()

local function set_battery_widget(icon_container, capacity_container)

    util_scripts.battery(function(icon, capacity)
        icon_container.widget.text = space .. icon .. space
        capacity_container.widget.markup =
            space .. utils.bold_markup(capacity) .. space
    end)
end

local function set_volume_widget(icon_container, volume_container)
    util_scripts.volume(function(icon, volume)
        icon_container.widget.text = space .. icon .. space
        volume_container.widget.markup =
            space .. utils.bold_markup(volume) .. space
    end)
end

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

function widgets.battery(timer)
    local battery_widget = {}
    local icon_container = wibox.container.background()
    local capacity_container = wibox.container.background()

    icon_container.widget = wibox.widget.textbox()
    icon_container.widget.font = theme.font

    capacity_container.widget = wibox.widget.textbox()
    capacity_container.widget.font = theme.font

    battery_widget.widget = wibox.widget {
        icon_container,
        capacity_container,
        layout = wibox.layout.align.horizontal
    }

    set_battery_widget(icon_container, capacity_container)
    timer:connect_signal("timeout", function()
        set_battery_widget(icon_container, capacity_container)
    end)

    return battery_widget
end

function widgets.time_date()
    local time_date_widget = {}
    local time_date_widget_container = wibox.container.background()

    local textclock = wibox.widget.textclock()
    textclock.format = utils.fontconfig(theme.font, space ..
                                            utils.bold_markup(
                                                "%a %d - %b  %H:%M %p") .. space)
    textclock.refresh = 60

    time_date_widget_container.widget = textclock

    time_date_widget.widget = wibox.widget {
        time_date_widget_container,
        layout = wibox.layout.align.horizontal
    }

    return time_date_widget
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

function widgets.volume(timer)

    local volume_widget = {}
    local icon_container = wibox.container.background()
    local volume_container = wibox.container.background()
    local popup_is_visible = false

    icon_container.widget = wibox.widget.textbox()
    icon_container.widget.font = theme.font

    volume_container.widget = wibox.widget.textbox()
    volume_container.widget.font = theme.font

    volume_widget.widget = wibox.widget {
        icon_container,
        volume_container,
        layout = wibox.layout.align.horizontal
    }

    set_volume_widget(icon_container, volume_container)

    timer:connect_signal("timeout", function()
        set_volume_widget(icon_container, volume_container)
    end)

    utils.handle_click(icon_container.widget, function()
        --
        util_scripts.toggle_mute(timer)
    end)

    utils.handle_click(volume_container.widget, function()
        if popup_is_visible then return end
        open_volume_popup(timer, function(visible)
            --
            popup_is_visible = visible
        end)
    end)

    return volume_widget
end

return widgets
