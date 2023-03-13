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

local function underline_shape(cr, width, height)
    cr:move_to(0, 0)
    cr:line_to(width, 0)
    cr:line_to(width, height - height / 2)
    cr:line_to(width - height / 2, height)
    cr:line_to(0, height)
    cr:close_path()
end

templetes.underlineable     = function(widget)
    return {
        widget,
        {
            {
                widget = wibox.container.margin
            },
            id            = templetes.ids.top_bar_underline_role,
            forced_height = 26,
            widget        = wibox.container.background,
        },
        layout = wibox.layout.fixed.vertical
    }
end

templetes.top_bar_item      = {
    templetes.underlineable({
        {
            id     = templetes.ids.top_bar_text_role,
            align  = "center",
            widget = wibox.widget.textbox,
        },
        left   = globals.dimensions.margin / 2,
        right  = globals.dimensions.margin / 2,
        widget = wibox.container.margin
    }),
    id     = templetes.ids.top_bar_background_role,
    widget = wibox.container.background,
    shape  = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true,
            globals.dimensions.corners_radius)
    end,
}

templetes.top_bar_task_item = {
    {
        {
            {
                id     = templetes.ids.top_bar_task_icon_role,
                widget = awful.widget.clienticon,
            },
            {
                id        = templetes.ids.top_bar_task_text_role,
                ellipsize = "middle",
                widget    = wibox.widget.textbox,
            },
            spacing = globals.dimensions.margin,
            layout = wibox.layout.fixed.horizontal,
        },
        margins = globals.dimensions.margin,
        widget = wibox.container.margin
    },
    id     = templetes.ids.top_bar_task_background_role,
    widget = wibox.container.background,
    shape  = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true,
            globals.dimensions.corners_radius)
    end,
}

templetes.horizontal_spacer = function(space)
    return {
        text = " ",
        widget = wibox.widget.textbox
    }
end

return templetes
