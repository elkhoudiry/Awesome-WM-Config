local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local util_widgets = {}

function util_widgets.slider_text_value(value, max, theme)

    local slider = wibox.widget {
        bar_shape = gears.shape.rounded_rect,
        forced_height = 20,
        forced_width = 50,
        bar_color = "#ffffff",
        bar_height = 3,
        handle_color = color_accent,
        handle_shape = gears.shape.circle,
        handle_border_color = theme.border_color,
        handle_border_width = 1,
        value = value,
        maximum = max,
        widget = wibox.widget.slider
    }

    local text = wibox.widget {
        text = tostring(value),
        widget = wibox.widget.textbox
    }

    local widg = {}
    widg.slider = slider
    widg.widget = wibox.widget {
        {
            {text = "Value: ", widget = wibox.widget.textbox},
            text,
            layout = wibox.layout.align.horizontal
        },
        slider,
        layout = wibox.layout.align.vertical
    }

    slider:connect_signal("property::value", function()
        text.text = tostring(slider.value)
        widg.value = slider.value
    end)

    return widg

end

function util_widgets.title_and_close(title)

    local close = ""
    for i = 1, string.len(title) - 1, 1 do close = close .. " " end
    close = close .. "X"

    local title_widget = wibox.widget {
        markup = title,
        widget = wibox.widget.textbox
    }

    local close_widget = wibox.widget {
        markup = "<b>" .. close .. "</b>",
        widget = wibox.widget.textbox
    }

    local widg = {}
    widg.title = title_widget
    widg.close = close_widget

    widg.widget = wibox.widget {
        title_widget,
        close_widget,
        forced_num_cols = 2,
        vertical_expand = true,
        layout = wibox.layout.grid
    }

    return widg

end

function util_widgets.textbox(text)
    return wibox.widget {text = text, widget = wibox.widget.textbox}
end

function util_widgets.popup(widget)
    local pop = awful.popup {
        widget = {widget, margins = 10, widget = wibox.container.margin},
        border_color = color_accent,
        border_width = 2,
        ontop = true
    }
    pop:move_next_to(mouse.current_widget_geometry)
    pop.visible = true

    return pop
end

return util_widgets
