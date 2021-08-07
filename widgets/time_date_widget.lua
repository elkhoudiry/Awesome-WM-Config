local wibox = require("wibox")
local common = require("../utils/common")
local theme = require("../theme")
local space = common.txt_space

local time_date_widget = {}

function time_date_widget.basic()
    local time_date_widget = {}
    local time_date_widget_container = wibox.container.background()

    local textclock = wibox.widget.textclock()
    local format = space .. common.bold_markup("%a %d - %b  %H:%M %p") .. space

    textclock.format = common.fontconfig(theme.font, format)
    textclock.refresh = 60

    time_date_widget_container.widget = textclock
    time_date_widget.widget = wibox.widget {
        time_date_widget_container,
        layout = wibox.layout.align.horizontal
    }

    return time_date_widget
end

return time_date_widget
