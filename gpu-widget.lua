local awful = require("awful")
local wibox = require("wibox")

require("global-utils")
local globals   = require("globals")
local templetes = require("templetes")

local command   = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"

local gpu       = {}

gpu.widget      = wibox.widget {
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

gpu.init        = function()
    gpu.refresh()
end

gpu.refresh     = function()
    shell.single_line(command, function(result)
        local color

        if tonumber(result) < globals.limits.gpu_temp then
            color = globals.colors.turquoise
        else
            color = globals.colors.error
        end

        local markup = text.icon_title_markup("󰹑",
            result .. "c",
            color,
            globals.colors.on_background
        )
        gpu.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1].bg = color
        gpu.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1].markup = markup
    end)
end

gpu.init()

return gpu
