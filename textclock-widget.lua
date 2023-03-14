local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals   = require("globals")
local templetes = require("templetes")

local clock     = {}

clock.widget    = wibox.widget {
    templetes.underlineable({
        format = text.icon_title_markup(
            "󰥔",
            "%a %b %d - %I:%M %p",
            globals.colors.tonys_pink,
            globals.colors.on_background
        ),
        widget = wibox.widget.textclock,
    }),
    id = templetes.ids.top_bar_background_role,
    bg = globals.colors.background .. globals.colors.alpha,
    widget = wibox.container.background
}

clock.init      = function()
    clock.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = globals.colors.tonys_pink
end

clock.init()

return clock
