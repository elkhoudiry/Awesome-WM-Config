local awful = require("awful")

local utils = {}
utils.txt_space = " "

function utils.bold_markup(text) return string.format("<b>%s</b>", text) end

function utils.fontconfig(font, text)
    return string.format("<span font='%s'>%s</span>", font, text)
end

function utils.round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function utils.split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function utils.ensure_length(text, length)

    local splits_1_length = string.len(text)

    while splits_1_length < length do
        text = " " .. text
        splits_1_length = splits_1_length + 1
    end

    return text
end

function utils.handle_click(w, cb)
    w:buttons(awful.util.table.join(awful.button({}, 1, function() cb() end)))
end

return utils
