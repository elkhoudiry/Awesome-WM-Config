---@diagnostic disable: lowercase-global
local awful = require("awful")
text = {}
arrays = {}
shell = {}
num = {}

function text.icon_title_markup(icon, text, icon_color, text_color)
    return string.format(
        "<span font_size=\"4pt\"> </span><span foreground=\"%s\" font_size=\"15pt\">%s</span><span foreground=\"%s\" rise=\"2pt\"> %s</span><span font_size=\"4pt\"> </span>",
        icon_color, icon,
        text_color, text
    )
end

function text.extract_pattern(s, pattern)
    return string.sub(s, string.find(s, pattern))
end

function text.extract_number(s)
    return tonumber(string.sub(s, string.find(s, "%d+%.?%d*")))
end

function text.extract_number_single_poing(s)
    return tonumber(string.sub(s, string.find(s, "%d+%.?%d")))
end

function text.extract_number_integer(s)
    return tonumber(string.sub(s, string.find(s, "%d+")))
end

function text.split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function num.round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function text.ensure_length(text, length)
    local splits_1_length = string.len(text)

    while splits_1_length < length do
        text = " " .. text
        splits_1_length = splits_1_length + 1
    end

    return text
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
