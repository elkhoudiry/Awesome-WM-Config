local wibox = require("wibox")
local common = require("../utils/common")
local kb_scripts = require("../scripts/kb_scripts")
local theme = require("../theme")
local space = common.txt_space

local function set_language_widget(language_container, layout)
    local layout_markup = common.bold_markup(string.upper(layout))
    language_container.widget.markup = space .. layout_markup .. space
end

local function switch_basic_layout(language_widget)
    if language_widget.layout == "us" then
        language_widget.layout = "ar"
    else
        language_widget.layout = "us"
    end

    local container = language_widget.widget.children[1]
    kb_scripts.set_kb_layout(language_widget.layout, function()
        set_language_widget(container, language_widget.layout)
    end)
end

local kb_layout = {}

function kb_layout.basic()
    local language_widget = {}
    local language_container = wibox.container.background()

    language_container.widget = wibox.widget.textbox()
    language_container.widget.font = theme.font

    language_widget.layout = "us"
    language_widget.widget = wibox.widget {
        language_container,
        layout = wibox.layout.align.horizontal
    }
    language_widget.switch = function() switch_basic_layout(language_widget) end

    common.handle_click(language_widget.widget, function() --
        language_widget.switch()
    end)

    set_language_widget(language_container, language_widget.layout)
    return language_widget
end

return kb_layout
