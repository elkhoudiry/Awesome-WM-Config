local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals      = require("globals")
local templetes    = require("templetes")

local ram_command  = "free | awk '/^Mem:/ { print \"used:\"$3 \", total:\"$2}'"
local swap_command = "free -h | awk '/^Swap:/ { print $3 }'"
local memory       = {}

memory.widget      = wibox.widget {
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

memory.init        = function()
    memory.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = globals.colors.purple
    memory.refresh()
end

memory.refresh     = function()
    shell.single_line(ram_command, function(ram)
        shell.single_line(swap_command, function(swap)
            local used_value = text.extract_number(string.sub(ram, string.find(ram, "used:%d+%.?%d*")))
            local total_value = text.extract_number(string.sub(ram, string.find(ram, "total:%d+%.?%d*")))
            local swap_value = text.extract_number(swap)

            local is_critical
            local color
            local ram = text.extract_number_single_poing(used_value / 1024 / 1024) .. "Gi"
            local ram_text = string.lower(string.sub(ram, 1, string.len(ram) - 1))
            if (used_value * 100 / total_value) > globals.limits.ram_percent then is_critical = true else is_critical = false end
            if is_critical then color = globals.colors.error else color = globals.colors.purple end

            if swap_value > 0 then
                local swap_text = string.sub(swap, 1, string.len(swap) - 1)
                ram_text = ram_text .. " - " .. string.lower(swap_text)
            end

            local markup = text.icon_title_markup("󰘚",
                ram_text,
                color,
                globals.colors.on_background)

            memory.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = color
            memory.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
        end)
    end)
end

memory.init()

return memory
