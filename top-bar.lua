local awful        = require("awful")
local gears        = require("gears")
local wibox        = require("wibox")
local naughty      = require("naughty")
local beautiful    = require("beautiful")
local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")


local globals = require("globals")

-- {{{ Wibar

local function get_desktop_markup(desktop, tag)
    local icon_color
    if (tag.selected) then icon_color = desktop.color_ontop else icon_color = desktop.color end
    return string.format(
        "<span font_size=\"4pt\"> </span><span foreground=\"%s\" font_size=\"15pt\">%s</span><span foreground=\"%s\" rise=\"2pt\"> %s</span><span font_size=\"4pt\"> </span>",
        icon_color, desktop.icon,
        desktop.color_ontop, desktop.name
    )
end

local function get_tag_primary_color(desktop, tag)
    local color
    if (tag.selected) then color = desktop.color else color = desktop.color_ontop end
    return color
end

local function get_tag_on_primary_color(desktop, tag)
    local color
    if (tag.selected) then color = desktop.color_ontop else color = desktop.color end
    return color
end

local function get_tag_normal_color(desktop, tag)
    local color
    if (tag.selected) then color = desktop.color else color = globals.colors.background end
    return color
end

-- Generate taglist squares:
local taglist_square_size       = xresources.apply_dpi(4)
beautiful.taglist_squares_sel   = theme_assets.taglist_squares_sel(
    taglist_square_size, globals.colors.white
)
beautiful.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, globals.colors.white
)
local function update_tag_properties(widget, desktop, tag)
    local background_color                                 = get_tag_primary_color(desktop, tag)
    local on_background_color                              = get_tag_on_primary_color(desktop, tag)
    local normal_color                                     = get_tag_normal_color(desktop, tag)
    widget:get_children_by_id('tag_text_role')[1].markup   = get_desktop_markup(desktop, tag)
    widget:get_children_by_id('tag_underline_role')[1].bg  = on_background_color
    widget:get_children_by_id('tag_background_role')[1].bg = normal_color
end

-- Keyboard map indicator and switcher
local keyboard_layout_indicator_widget = awful.widget.keyboardlayout()

-- Create a textclock widget
local text_clock_widget                = wibox.widget.textclock()

screen.connect_signal("request::desktop_decoration", function(screen)
    -- Each screen has its own tag table.
    awful.tag({ "", "", "", "", "" }, screen, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    screen.run_widget = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    screen.tiling_layouts_widget = awful.widget.layoutbox {
        screen  = screen,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }

    -- Create a taglist widget
    screen.desktops_list_widget = awful.widget.taglist {
        screen          = screen,
        filter          = awful.widget.taglist.filter.all,
        style           = {
            font = globals.font.full_modified(6),
            shape = gears.shape.rounded_rect
        },
        layout          = {
            spacing = 2,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = "tag_text_role",
                        align  = "center",
                        widget = wibox.widget.textbox,
                    },
                    left   = 2,
                    right  = 2,
                    widget = wibox.container.margin
                },
                {
                    id            = "tag_underline_role",
                    forced_height = 6,
                    widget        = wibox.container.background,
                },
                layout = wibox.layout.fixed.vertical,
            },
            id              = "tag_background_role",
            shape           = function(cr, width, height)
                return gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, 4)
            end,
            widget          = wibox.container.background,
            create_callback = function(self, tag, index, objects) --luacheck: no unused args
                local desktop = globals.tags[index]
                update_tag_properties(self, desktop, tag)
            end,
            update_callback = function(self, tag, index, objects) --luacheck: no unused args
                local desktop = globals.tags[index]
                update_tag_properties(self, desktop, tag)
            end,
        },
        buttons         = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create a tasklist widget
    beautiful.tasklist_disable_task_name = true
    screen.tasks_list_widget = awful.widget.tasklist {
        screen          = screen,
        filter          = awful.widget.tasklist.filter.currenttags,
        layout          = {
            spacing = 10,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left   = 2,
                right  = 2,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
        buttons         = {
            awful.button({}, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        }
    }

    -- Create the wibox
    screen.top_bar_widget = awful.wibar {
        position = "top",
        screen   = screen,
        bg       = beautiful.bg_normal .. "00",
        widget   = {
            layout = wibox.layout.align.horizontal,
            {
                -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                screen.desktops_list_widget,
                screen.run_widget,
            },
            {
                layout = wibox.layout.align.horizontal,
                wibox.widget.textbox(""),
                screen.tasks_list_widget,
                wibox.widget.textbox(" "),
                expand = "outside"
            },
            {
                -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                keyboard_layout_indicator_widget,
                wibox.widget.systray(),
                text_clock_widget,
                screen.tiling_layouts_widget,
            },
        }
    }
end)

-- }}}
