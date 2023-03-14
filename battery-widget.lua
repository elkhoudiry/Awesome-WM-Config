local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals          = require("globals")
local templetes        = require("templetes")

local status_command   = "cat /sys/class/power_supply/\"BAT0\"/status"
local capacity_command = "cat /sys/class/power_supply/\"BAT0\"/capacity"

local battery          = {}

battery.widget         = wibox.widget {
    templetes.underlineable({
        id     = templetes.ids.top_bar_text_role,
        align  = "center",
        text   = "",
        valign = "center",
        fg     = globals.colors.on_background,
        widget = wibox.widget.textbox,
    }),
    id = templetes.ids.top_bar_background_role,
    bg = globals.colors.background .. globals.colors.alpha,
    widget = wibox.container.background
}

battery.init           = function()
    battery.refresh()
end

battery.refresh        = function()
    shell.single_line(status_command, function(status)
        shell.single_line(capacity_command, function(capacity)
            local is_charging
            local icon
            local color = globals.colors.orangish
            local capacity_value = tonumber(capacity)

            local text_widget = battery.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1]
            local underline_widget = battery.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1]

            if status == "Charging" then
                icon = "󰚥"
                color = globals.colors.success
            end

            if capacity_value > 95 and capacity_value >= 100 then
                icon = "󰁹"
            elseif capacity_value > 90 and capacity_value <= 95 then
                icon = "󰂂"
            elseif capacity_value > 80 and capacity_value <= 90 then
                icon = "󰂁"
            elseif capacity_value > 70 and capacity_value <= 80 then
                icon = "󰂀"
            elseif capacity_value > 60 and capacity_value <= 70 then
                icon = "󰁿"
            elseif capacity_value > 50 and capacity_value <= 60 then
                icon = "󰁾"
            elseif capacity_value > 40 and capacity_value <= 50 then
                icon = "󰁽"
            elseif capacity_value > 30 and capacity_value <= 40 then
                icon = "󰁼"
            elseif capacity_value > 15 and capacity_value <= 30 then
                icon = "󰁻"
            else
                color = globals.colors.error
                icon = "󰂃"
            end

            underline_widget.bg = color
            text_widget.markup = text.icon_title_markup(
                icon,
                capacity,
                color,
                globals.colors.on_background
            )
        end)
    end)
end

battery.init()

return battery
