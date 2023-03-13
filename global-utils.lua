---@diagnostic disable: lowercase-global
local awful = require("awful")
text = {}
arrays = {}
shell = {}

function text.icon_title_markup(icon, text, icon_color, text_color)
    return string.format(
        "<span font_size=\"4pt\"> </span><span foreground=\"%s\" font_size=\"15pt\">%s</span><span foreground=\"%s\" rise=\"2pt\"> %s</span><span font_size=\"4pt\"> </span>",
        icon_color, icon,
        text_color, text
    )
end

function text.extract_number(s)
    return tonumber(string.sub(s, string.find(s, "%d+%.?%d*")))
end

function arrays.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function shell.single_line(command, cb)
    awful.spawn.easy_async_with_shell(command, function(result)
        cb(string.gsub(result, "\n", ""))
    end)
end
