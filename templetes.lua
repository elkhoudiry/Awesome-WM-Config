local gears                                = require("gears")
local awful                                = require("awful")
local wibox                                = require("wibox")

local templetes                            = {}

templetes.ids                              = {}
templetes.ids.top_bar_text_role            = "top_bar_text_role"
templetes.ids.top_bar_underline_role       = "top_bar_underline_role"
templetes.ids.top_bar_background_role      = "top_bar_background_role"
templetes.ids.top_bar_task_background_role = "top_bar_task_background_role"
templetes.ids.top_bar_task_icon_role       = "top_bar_task_icon_role"

templetes.top_bar_item                     = {
    {
        {
            {
                {
                    id     = templetes.ids.top_bar_text_role,
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                left   = 2,
                right  = 2,
                widget = wibox.container.margin
            },
            {
                id            = templetes.ids.top_bar_underline_role,
                forced_height = 2,
                widget        = wibox.container.background,
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 0,
        widget = wibox.container.margin
    },
    id     = templetes.ids.top_bar_background_role,
    widget = wibox.container.background,
    shape  = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, 6)
    end,
}

templetes.top_bar_task_item                = {
    {
        {
            {
                id     = templetes.ids.top_bar_task_icon_role,
                widget = awful.widget.clienticon,
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 4,
        widget = wibox.container.margin
    },
    id     = templetes.ids.top_bar_task_background_role,
    widget = wibox.container.background,
    shape  = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 6)
    end,
}

return templetes
