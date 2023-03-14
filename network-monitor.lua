local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals   = require("globals")
local templetes = require("templetes")

local cmd       = function(devices)
    return "echo $(sh $HOME/.config/awesome/network-script.sh -d '" .. devices .. "')"
end

local network   = {}

local function get_printable_speed(number)
    local units = { " b", "kb", "mb", "gb" }
    local counter = 1

    while number >= 100 do
        number = number / 1024
        counter = counter + 1
    end

    local splits = text.split(tostring(num.round(number, 2)), ".")

    if string.len(splits[2]) == 1 then splits[2] = splits[2] .. "0" end
    splits[1] = text.ensure_length(splits[1], 2)
    return splits[1] .. "." .. splits[2] .. "" .. units[counter] .. "/s"
end

network.nics    = { "wlp0s20f3", "enp60s0" }

network.widget  = wibox.widget {
    layout = wibox.layout.fixed.horizontal
}

network.init    = function()
    for _, value in ipairs(network.nics) do
        table.insert(network.widget.children, wibox.widget {
            templetes.underlineable({
                id     = templetes.ids.top_bar_text_role .. "_" .. value,
                align  = "center",
                text   = "",
                valign = "center",
                tx     = 0,
                rx     = 0,
                time   = 0,
                fg     = globals.colors.on_background,
                widget = wibox.widget.textbox,
            }),
            id = templetes.ids.top_bar_background_role .. "_" .. value,

            bg = globals.colors.background .. globals.colors.alpha,
            widget = wibox.container.background
        })
    end

    network.refresh()
end

network.refresh = function()
    local command = cmd(table.concat(network.nics, " "))
    shell.single_line(command, function(result)
        local splits = text.split(result, " || ")

        for index, value in ipairs(splits) do
            local is_connected_match = text.extract_pattern(value, "#%w+")
            local text_widget = network.widget.children[index].widget.children[1]
            local underline_widget = network.widget.children[index].widget.children[2]
            local is_connected
            local color = globals.colors.your_pink

            if string.sub(is_connected_match, 2, string.len(is_connected_match)) == "connected" then
                is_connected = true
            else
                is_connected = false
            end

            if not is_connected then
                text_widget.markup = text.icon_title_markup(
                    "󰌙",
                    "",
                    color,
                    globals.colors.on_background
                )
                underline_widget.bg = color
            else
                local current_rx = text.extract_number(text.extract_pattern(value, "-%d+"))
                local current_tx = text.extract_number(text.extract_pattern(value, "+%d+"))
                local current_time = os.time()
                local rx = (current_rx - text_widget.rx) / (current_time - text_widget.time)
                local tx = (current_tx - text_widget.tx) / (current_time - text_widget.time)

                if rx > globals.limits.download_speed then
                    color = globals.colors.success
                end

                text_widget.markup = text.icon_title_markup(
                    "󰌘",
                    get_printable_speed(rx) .. " " .. get_printable_speed(tx),
                    color,
                    globals.colors.on_background
                )
                text_widget.rx = current_rx
                text_widget.tx = current_tx
                text_widget.time = current_time
                underline_widget.bg = color
            end
        end
    end)
end

network.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    network.refresh()
end)))


network.init()

return network
