local wibox = require("wibox")
local common = require("../utils/common")
local battery_scripts = require("../scripts/battery_scripts")
local theme = require("../theme")
local space = common.txt_space

local battery_widget = {}

local function set_battery_widget(icon_container, capacity_container)
    battery_scripts.get_basic_battery(function(icon, capacity)
        icon_container.widget.text = space .. icon .. space
        capacity_container.widget.markup =
            space .. common.bold_markup(capacity) .. space
    end)
end

function battery_widget.basic(timer)
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

return battery_widget
