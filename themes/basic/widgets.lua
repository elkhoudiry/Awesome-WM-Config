local wibox = require("wibox")
local awful = require("awful")
local common = require("../utils/common")
local util_widgets = require("../utils/util_widgets")

local basic_module = {}
local space = common.txt_space

-- [[ ################################################################### ]] --
-- [[ ############# BATTERY HELPER FUNCTIONS #############

local function get_basic_battery(battery_name, callback)
    local status_cmd = -- =======>
    "cat /sys/class/power_supply/" .. battery_name .. "/status"
    local capacity_cmd = -- ======>
    "cat /sys/class/power_supply/" .. battery_name .. "/capacity"

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

local function set_battery_widget(battery_package)
    battery_package.icon_container.widget.text =
        space .. battery_package.icon .. space
    battery_package.capacity_container.widget.markup = -- =======>  
    space .. common.bold_markup(battery_package.level) .. space
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# KEYBOARD HELPER FUNCTIONS #############

local function get_volume_level(cb)
    local cmd = "pamixer --get-volume"
    awful.spawn.easy_async_with_shell(cmd, function(vol) cb(vol) end)
end

local function get_basic_volume(callback)
    get_volume_level(function(volume)
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
                callback("奄", common.ensure_length(tostring(volNum), 3))
            else
                callback("墳", common.ensure_length(tostring(volNum), 3))
            end
        end)
    end)
end

local function toggle_mute(callback)
    awful.spawn.easy_async_with_shell("pamixer -t", function() callback() end)
end

local function set_volume_level(value)
    local cmd = "pamixer  --allow-boost --set-volume " .. value
    awful.spawn.easy_async_with_shell(cmd, function() end)
end

local function set_volume_widget(volume_widget)
    volume_widget.icon_container.widget.text = --
    space .. volume_widget.icon .. space
    volume_widget.volume_container.widget.markup = --
    space .. common.bold_markup(volume_widget.level) .. space
end

local function init_volume_popup(volume_package)
    local popup = {}
    popup.title_widget = util_widgets.title_and_close("Volume  ")
    popup.slider_widget = util_widgets.slider_text_value( -- ====>
    tonumber(volume_package.level), 125)

    local widget = {
        popup.title_widget.widget,
        popup.slider_widget.widget,
        layout = wibox.layout.align.vertical
    }

    popup.widget = util_widgets.popup(widget)

    common.handle_click(popup.title_widget.close, function() --
        popup.widget.visible = false
    end)

    popup.slider_widget.slider:connect_signal("property::value", function() --
        set_volume_level(popup.slider_widget.slider.value)
    end)

    popup.slider_widget.slider:connect_signal("mouse::leave", function() --
        volume_package.refresh()
    end)

    popup.widget:connect_signal("mouse::leave", function() --
        volume_package.refresh()
    end)

    popup.widget:move_next_to(mouse.current_widget_geometry)
    popup.widget.visible = false
    return popup
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# KEYBOARD HELPER FUNCTIONS #############

local function set_language_widget(widget, layout)
    local layout_markup = common.bold_markup(string.upper(layout))
    widget.children[1].widget.markup = space .. layout_markup .. space
end

local function set_kb_layout(layout, callback)
    local cmd = "setxkbmap " .. layout
    awful.spawn.easy_async(cmd, function() callback() end)
end

local function switch_basic_layout(language_widget)
    if language_widget.layout == "us" then
        language_widget.layout = "ar"
    else
        language_widget.layout = "us"
    end

    set_kb_layout(language_widget.layout, function()
        set_language_widget(language_widget.widget, language_widget.layout)
    end)
end

-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# CONNECTIVITY HELPER FUNCTIONS #############

local function get_printable_speed(number)
    local units = {" B", "KB", "MB", "GB"}
    local counter = 1

    while number >= 100 do
        number = number / 1024
        counter = counter + 1
    end

    local splits = common.split(tostring(common.round(number, 2)), ".")

    if string.len(splits[2]) == 1 then splits[2] = splits[2] .. "0" end
    splits[1] = common.ensure_length(splits[1], 2)
    return splits[1] .. "." .. splits[2] .. " " .. units[counter] .. "/s"
end

local function update_devices_widgets(devices)
    for _, device in ipairs(devices) do
        device.container.widget.children[1].text = space .. device.icon .. space

        if device.connected then
            if not device.container.widget.children[2].visible then
                device.container.widget.children[2].visible = true
                device.container.widget.children[3].visible = true
            end
            device.container.widget.children[2].markup =
                common.bold_markup( --
                space .. get_printable_speed(device.tmp_rx - device.rx) .. space)
            device.container.widget.children[3].markup =
                common.bold_markup( --
                space .. get_printable_speed(device.tmp_tx - device.tx) .. space)
        else
            if device.container.widget.children[2].visible then
                device.container.widget.children[2].visible = false
                device.container.widget.children[3].visible = false
            end
        end
        device.rx = device.tmp_rx
        device.tx = device.tmp_tx
    end
end

local function update_devices_state(devices, states)
    for index, _ in ipairs(devices) do
        local splits = common.split(states[index], " ")

        if string.find(splits[1], "dis") == nil then
            devices[index].connected = true
            devices[index].icon = devices[index].icons_table[1]
            devices[index].tmp_rx = splits[2]
            devices[index].tmp_tx = splits[3]
        else
            devices[index].tmp_rx = 0
            devices[index].tmp_tx = 0
            devices[index].connected = false
            devices[index].icon = devices[index].icons_table[2]
        end
    end
end

local function get_device_connection_state(device_name, callback)
    local cmd = "nmcli | grep " .. device_name .. ":"
    awful.spawn.easy_async_with_shell(cmd, function(out) callback(out) end)
end

local function get_devices_state(all_devices_str, callback)
    awful.spawn.easy_async_with_shell(
        " echo $(sh $HOME/.config/awesome/shell_scripts/connectivity/basic_script.sh -d '" ..
            all_devices_str .. "') ", function(out) -- 
            callback(common.split(out, "||"))
        end)
end

local function init_devices(package, devices, wired)
    for _, device_name in ipairs(devices) do
        local device = {}

        device.name = device_name
        device.wired = wired
        device.conneced = false
        device.icons_table = wired and {"", ""} or {"直", "睊"}
        device.icon = ""
        device.rx = 0
        device.tx = 0
        device.tmp_rx = 0
        device.tmp_tx = 0
        device.container = wibox.container.background()
        device.container.widget = wibox.widget {
            layout = wibox.layout.align.horizontal,
            {widget = wibox.widget.textbox, text = "IC "},
            {widget = wibox.widget.textbox, text = "RX "},
            {widget = wibox.widget.textbox, text = "TX "}
        }

        local tooltip = awful.tooltip {objects = {device.container}}
        tooltip.visible = false

        device.container:connect_signal("mouse::enter", function()
            tooltip.visible = true
            tooltip.text = ""
            get_device_connection_state(device.name, function(state)
                tooltip.text = state
            end)
        end)

        device.container:connect_signal("mouse::leave", function() --
            tooltip.visible = false
        end)

        if wired then
            table.insert(package.wired_layout, device.container)
        else
            table.insert(package.wifi_layout, device.container)
        end
        table.insert(package.all_devices, device)
        package.all_devices_str = package.all_devices_str .. device.name .. " "
    end
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ################################################################### ]] --
-- [[ ################################################################### ]] --

-- [[ ############# WIDGETS #############

-- [[ ################################################################### ]] --
-- [[ ############# CONNECTIVITY WIDGETS #############

function basic_module.basic_connectivity(wired_devices, wifi_devices)
    local package = {}
    package.all_devices = {}
    package.wired_layout = {layout = wibox.layout.align.horizontal}
    package.wifi_layout = {layout = wibox.layout.align.horizontal}

    package.all_devices_str = ""

    init_devices(package, wired_devices, true)
    init_devices(package, wifi_devices, false)

    package.widget = wibox.widget {
        package.wired_layout,
        package.wifi_layout,
        layout = wibox.layout.align.horizontal
    }

    package.refresh = function()
        get_devices_state(package.all_devices_str, function(states)
            update_devices_state(package.all_devices, states)
            update_devices_widgets(package.all_devices)
        end)
    end

    package.refresh()
    return package
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# KEYBOARD LAYOUT WIDGET #############

function basic_module.basic_kb_layout()
    local language_widget = {}
    language_widget.layout = "us"
    language_widget.widget = wibox.widget {
        {{widget = wibox.widget.textbox}, widget = wibox.container.background},
        layout = wibox.layout.align.horizontal
    }
    language_widget.switch = function() switch_basic_layout(language_widget) end

    common.handle_click(language_widget.widget, function() --
        language_widget.switch()
    end)

    language_widget.refresh = function()
        set_language_widget(language_widget.widget, language_widget.layout)
    end

    language_widget.refresh()
    return language_widget
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# TIME AND DATE WIDGET #############

function basic_module.basic_time_date()
    local time_date_widget = {}
    local time_date_widget_container = wibox.container.background()

    local textclock = wibox.widget.textclock()
    local format = space .. common.bold_markup("%a %d - %b  %H:%M %p") .. space

    textclock.format = format
    textclock.refresh = 60

    time_date_widget_container.widget = textclock
    time_date_widget.widget = wibox.widget {
        time_date_widget_container,
        layout = wibox.layout.align.horizontal
    }

    return time_date_widget
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# VOLUME WIDGET #############

function basic_module.basic_volume()
    local volume_package = {}
    volume_package.icon_container = wibox.container.background()
    volume_package.volume_container = wibox.container.background()

    volume_package.icon_container.widget = wibox.widget.textbox()
    volume_package.volume_container.widget = wibox.widget.textbox()

    volume_package.icon = ""
    volume_package.level = ""

    volume_package.popup = init_volume_popup(volume_package)

    volume_package.refresh = function()
        get_basic_volume(function(icon, level) --
            volume_package.icon = icon
            volume_package.level = level
            volume_package.popup.slider_widget.slider.value = tonumber(level)
            set_volume_widget(volume_package)
        end)
    end

    volume_package.widget = wibox.widget {
        volume_package.icon_container,
        volume_package.volume_container,
        layout = wibox.layout.align.horizontal
    }

    volume_package.widget:connect_signal("volumechanged", function() --
        set_volume_widget(volume_package)
    end)

    common.handle_click(volume_package.icon_container.widget, function() --
        toggle_mute(function() volume_package.refresh() end)
    end)

    common.handle_click(volume_package.volume_container.widget, function() --
        if (volume_package.popup.widget.visible) then
            volume_package.popup.widget.visible = false
        else
            volume_package.popup.widget:move_next_to(
                mouse.current_widget_geometry)
            volume_package.popup.widget.visible = true
        end
    end)

    volume_package.refresh()
    return volume_package
end
-- ]]

-- [[ ################################################################### ]] --
-- [[ ############# BATTERY WIDGET #############

function basic_module.basic_battery(battery_name)
    local battery_package = {}

    battery_package.icon_container = wibox.container.background()
    battery_package.capacity_container = wibox.container.background()

    battery_package.icon_container.widget = wibox.widget.textbox()
    battery_package.capacity_container.widget = wibox.widget.textbox()

    battery_package.icon = ""
    battery_package.level = ""

    battery_package.refresh = function(num)
        get_basic_battery("BAT0", function(icon, level) -- 
            battery_package.icon = icon
            battery_package.level = level
            set_battery_widget(battery_package)
        end)
    end

    battery_package.widget = wibox.widget {
        battery_package.icon_container,
        battery_package.capacity_container,
        layout = wibox.layout.align.horizontal
    }

    battery_package.refresh()
    return battery_package
end
-- ]]

-- ]]

return basic_module
