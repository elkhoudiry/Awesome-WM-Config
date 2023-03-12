local gears                                = require("gears")
local awful                                = require("awful")
local wibox                                = require("wibox")
local globals                              = require("globals")

local templetes                            = {}

templetes.ids                              = {}
templetes.ids.top_bar_text_role            = "top_bar_text_role"
templetes.ids.top_bar_underline_role       = "top_bar_underline_role"
templetes.ids.top_bar_background_role      = "top_bar_background_role"
templetes.ids.top_bar_task_background_role = "top_bar_task_background_role"
templetes.ids.top_bar_task_icon_role       = "top_bar_task_icon_role"
templetes.ids.top_bar_task_text_role       = "top_bar_task_text_role"

templetes.underlineable                    = function(widget)
    return {
        widget,
        {
            id            = templetes.ids.top_bar_underline_role,
            forced_height = 2,
            bg            = globals.tags.current().color_ontop,
            widget        = wibox.container.background,
        },
        layout = wibox.layout.fixed.vertical,
    }
end

templetes.top_bar_item                     = {
    {
        templetes.underlineable({
            {
                id     = templetes.ids.top_bar_text_role,
                align  = "center",
                widget = wibox.widget.textbox,
            },
            left   = 2,
            right  = 2,
            widget = wibox.container.margin
        }),
        margins = 0,
        widget = wibox.container.margin
    },
    id     = templetes.ids.top_bar_background_role,
    widget = wibox.container.background,
    shape  = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 4)
    end,
}

templetes.top_bar_task_item                = {
    {
        {
            {
                id     = templetes.ids.top_bar_task_icon_role,
                widget = awful.widget.clienticon,
            },
            {
                id     = templetes.ids.top_bar_task_text_role,
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 4,
        widget = wibox.container.margin
    },
    id     = templetes.ids.top_bar_task_background_role,
    widget = wibox.container.background,
    shape  = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 4)
    end,
}

templetes.horizontal_spacer                = function(space)
    return {
        text = " ",
        widget = wibox.widget.textbox
    }
end

return templetes
