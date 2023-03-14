local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals             = require("globals")
local templetes           = require("templetes")

local temperature_command = "sensors | awk '/Package id/{print $4}'"
local cpu_usage_command   = "top -i -b -n1 | sed 1,7d | head -n 1 | awk '{print $9\"% \"$12}'"

local cpu                 = {}

cpu.widget                = wibox.widget {
    templetes.underlineable({
        id     = templetes.ids.top_bar_text_role,
        align  = "center",
        text   = "",
        valign = "center",
        fg     = globals.colors.on_background,
        widget = wibox.widget.textbox,
    }),
    id = templetes.ids.top_bar_background_role,
    bg = globals.colors.background .. globals.colors.alpha,
    widget = wibox.container.background
}

function cpu.init()
    cpu.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = globals.colors.turquoise
    cpu.refresh()
end

cpu.refresh = function()
    shell.single_line(temperature_command, function(temperature)
        local temperature = text.extract_number_integer(temperature)
        if temperature < globals.limits.cpu_temp then
            local cpu_text = tostring(temperature) .. "c"
            local color = globals.colors.turquoise
            local markup = text.icon_title_markup("󰻠",
                cpu_text,
                color,
                globals.colors.on_background
            )
            cpu.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = color
            cpu.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
        else
            shell.single_line(cpu_usage_command, function(usage)
                local cpu_text = tostring(temperature) .. "c - " .. string.lower(usage)
                local color = globals.colors.error
                local markup = text.icon_title_markup("󰻠",
                    cpu_text,
                    color,
                    globals.colors.on_background
                )
                cpu.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = color
                cpu.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
            end)
        end
    end)
end

cpu.init()

return cpu
