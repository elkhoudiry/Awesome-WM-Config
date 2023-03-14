local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local volume_command = "pamixer --get-volume"
local check_mute_command = "pamixer --get-mute"

require("global-utils")
local globals       = require("globals")
local templetes     = require("templetes")

local volume        = {}

volume.widget       = wibox.widget {
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

volume.widget.color = globals.colors.light_green

volume.init         = function()
    volume.refresh()
end

volume.refresh      = function()
    shell.single_line(check_mute_command, function(is_muted)
        if is_muted == "false" then is_muted = false else is_muted = true end
        shell.single_line(volume_command, function(result)
            local volume_value = tonumber(result)
            local text_widget = volume.widget:get_children_by_id(templetes.ids.top_bar_text_role)[1]
            local underline_widget = volume.widget:get_children_by_id(templetes.ids.top_bar_underline_role)[1]

            local color = volume.widget.color
            local icon

            if is_muted then
                icon = "󰝟"
            elseif volume_value > 70 and volume_value <= 100 then
                icon = "󰕾"
            elseif volume_value > 30 and volume_value <= 70 then
                icon = "󰖀"
            elseif volume_value >= 0 and volume_value <= 30 then
                icon = "󰕿"
            else
                icon = "󰓃"
            end

            text_widget.markup = text.icon_title_markup(
                icon,
                result .. "%",
                color,
                globals.colors.on_background
            )
            volume.widget.value = volume_value
            underline_widget.bg = color
        end)
    end)
end

volume.init()

volume.slider = wibox.widget {
    bar_shape           = gears.shape.rounded_rect,
    bar_height          = 3,
    bar_color           = volume.widget.color,
    handle_color        = volume.widget.color,
    handle_shape        = gears.shape.circle,
    handle_border_color = volume.widget.color,
    handle_border_width = 0,
    value               = 100,
    maximum             = 125,
    widget              = wibox.widget.slider,
}

volume.slider.mute = wibox.widget {
    text = "󰝟 ",
    widget = wibox.widget.textbox
}

volume.slider.mute:buttons(awful.util.table.join(awful.button({}, 1, function()
    shell.single_line("pamixer -t", function()
        volume.refresh()
    end)
end)))

volume.popup = awful.popup {
    widget         = {
        {
            {
                {
                    text = "Volume",
                    widget = wibox.widget.textbox
                },
                {
                    widget = wibox.container.background

                },
                volume.slider.mute,
                layout = wibox.layout.align.horizontal
            },
            {
                widget = wibox.container.background
            },
            volume.slider,
            layout = wibox.layout.align.vertical,
        },
        forced_height = 50,
        forced_width  = 125,
        margins       = globals.dimensions.margin,
        widget        = wibox.container.margin
    },
    shape          = function(cr, width, height)
        return gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true,
            globals.dimensions.corners_radius)
    end,
    ontop          = true,
    current_anchor = "front",
    visible        = false,
    border_width   = globals.dimensions.border_width,
    offset         = {
        y = globals.dimensions.gap_size,
    },
}

volume.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    if volume.popup.visible then
        volume.popup.visible = false
    else
        volume.popup.visible = true
        volume.slider.value = volume.widget.value
        volume.popup.border_color = volume.widget.color
        volume.popup:move_next_to(mouse.current_widget_geometry)
    end
end)))

volume.slider:connect_signal("property::value", function()
    shell.single_line("pamixer  --allow-boost --set-volume " .. volume.slider.value, function()
        volume.refresh()
    end)
end)

return volume
