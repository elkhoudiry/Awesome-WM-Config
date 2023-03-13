local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals      = require("globals")
local templetes    = require("templetes")

local ram_command  = "free -h | awk '/^Mem:/ { print $3 }'"
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
            local ram_text = string.sub(ram, 1, string.len(ram) - 1)
            local swap_value = text.extract_number(swap)

            if swap_value > 0 then
                local swap_text = string.sub(swap, 1, string.len(swap) - 1)
                ram_text = ram_text .. " - " .. swap_text
            end

            local markup = text.icon_title_markup("󰘚",
                ram_text,
                globals.colors.purple,
                globals.colors.on_background)
            memory.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
        end)
    end)
end

memory.init()

return memory
