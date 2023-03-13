local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals            = require("globals")
local templetes          = require("templetes")

local keyboard_layout    = {}
local get_layout_command = "setxkbmap -query | awk '/layout/ {print $2}'"

keyboard_layout.widget   = wibox.widget {
    templetes.underlineable({
        id     = templetes.ids.top_bar_text_role,
        align  = "center",
        text   = "asdasd",
        valign = "center",
        fg     = globals.colors.on_background,
        widget = wibox.widget.textbox,
    }),
    id = templetes.ids.top_bar_background_role,
    bg = globals.colors.background .. globals.colors.alpha,
    widget = wibox.container.background
}

keyboard_layout.init     = function()
    keyboard_layout.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = globals.colors.green
    keyboard_layout.refresh()
end

keyboard_layout.refresh  = function()
    awful.spawn.easy_async_with_shell(get_layout_command, function(result)
        local layout = string.gsub(result, "\n", "")
        local markup = text.icon_title_markup("󰇧", layout, globals.colors.green, globals.colors.on_background)
        keyboard_layout.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
    end)
end

return keyboard_layout
