local awful = require("awful")

local common = {}
common.txt_space = " "

function common.bold_markup(text) return string.format("<b>%s</b>", text) end

function common.fontconfig(font, text)
    return string.format("<span font='%s'>%s</span>", font, text)
end

function common.round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function common.split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function common.table_to_string(table)
    local result = ""
    for i, b in ipairs(table) do result = result .. " " .. b.name .. " " end
    return result
end

function common.ensure_length(text, length)

    local splits_1_length = string.len(text)

    while splits_1_length < length do
        text = " " .. text
        splits_1_length = splits_1_length + 1
    end

    return text
end

function common.handle_click(w, cb)
    w:buttons(awful.util.table.join(awful.button({}, 1, function() cb() end)))
end

function common.destroy_widget(widget)
    local children = widget:get_all_children()
    for index, _ in ipairs(children) do children[index] = nil end
    widget = nil
end

return common
