local wibox = require("wibox")
local common = require("../utils/common")
local volume_scripts = require("../scripts/volume_scripts")
local util_widgets = require("../utils/util_widgets")
local theme = require("../theme")
local space = common.txt_space

local function set_volume_widget(icon_container, volume_container)
    volume_scripts.get_basic_volume(function(icon, volume)
        icon_container.widget.text = space .. icon .. space
        volume_container.widget.markup =
            space .. common.bold_markup(volume) .. space
    end)
end

local function open_volume_popup(timer, callback)
    volume_scripts.get_volume_level(function(volume)
        local title_widget = util_widgets.title_and_close("Volume  ")
        local slider_widget = util_widgets.slider_text_value(tonumber(volume),
                                                             125, theme)
        local popup_widget = {
            title_widget.widget,
            slider_widget.widget,
            layout = wibox.layout.align.vertical
        }

        local pop = util_widgets.popup(popup_widget)
        callback(true)
        common.handle_click(title_widget.close, function() --
            pop.visible = false
            callback(false)
        end)

        slider_widget.slider:connect_signal("property::value", function() --
            volume_scripts.set_volume_level(slider_widget.slider.value, timer)
        end)
    end)
end

local volume_widget = {}

function volume_widget.basic(timer)

    local volume_widget = {}
    local icon_container = wibox.container.background()
    local volume_container = wibox.container.background()
    local popup_is_visible = false

    icon_container.widget = wibox.widget.textbox()
    icon_container.widget.font = theme.font

    volume_container.widget = wibox.widget.textbox()
    volume_container.widget.font = theme.font

    volume_widget.widget = wibox.widget {
        icon_container,
        volume_container,
        layout = wibox.layout.align.horizontal
    }

    set_volume_widget(icon_container, volume_container)

    timer:connect_signal("timeout", function()
        set_volume_widget(icon_container, volume_container)
    end)

    common.handle_click(icon_container.widget, function() --
        volume_scripts.toggle_mute(timer)
    end)

    common.handle_click(volume_container.widget, function()
        if popup_is_visible then return end
        open_volume_popup(timer, function(visible)
            --
            popup_is_visible = visible
        end)
    end)

    return volume_widget
end

return volume_widget
