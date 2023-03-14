local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals            = require("globals")
local templetes          = require("templetes")

local keyboard_layout    = {}
local get_layout_command = "setxkbmap -query | awk '/layout/ {print $2}'"

keyboard_layout.layouts  = { "us", "ar" }

keyboard_layout.widget   = wibox.widget {
    templetes.underlineable({
        id     = templetes.ids.top_bar_text_role,
        align  = "center",
        text   = keyboard_layout.layouts[1],
        valign = "center",
        fg     = globals.colors.on_background,
        widget = wibox.widget.textbox,
    }),
    id = templetes.ids.top_bar_background_role,
    bg = globals.colors.background .. globals.colors.alpha,
    widget = wibox.container.background
}

keyboard_layout.init     = function()
    keyboard_layout.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = globals.colors.turquoise
    keyboard_layout.refresh()
end

keyboard_layout.refresh  = function()
    awful.spawn.easy_async_with_shell(get_layout_command, function(result)
        local layout = string.gsub(result, "\n", "")
        local markup = text.icon_title_markup("󰇧", layout, globals.colors.turquoise, globals.colors.on_background)
        keyboard_layout.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
    end)
end

local toggle             = function()
    awful.spawn.easy_async_with_shell(get_layout_command, function(result)
        local index = arrays.indexOf(keyboard_layout.layouts, string.gsub(result, "\n", ""))
        local layout
        if index == #keyboard_layout.layouts then
            layout = keyboard_layout.layouts[1]
        else
            layout = keyboard_layout.layouts[index + 1]
        end

        awful.spawn.easy_async_with_shell("setxkbmap " .. layout, function(result)
            keyboard_layout.refresh()
        end)
    end)
end

keyboard_layout.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    toggle()
end)))

awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "space", function() toggle() end, { description = "toggle language", group = "layout" }),
})

keyboard_layout.init()

return keyboard_layout
