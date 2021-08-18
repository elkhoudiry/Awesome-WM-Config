---------------------------
-- Default awesome theme --
---------------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local basic_widgets = require("themes/basic/widgets")

local theme = {}

local color_accent = "#F8708C"
local color_background = "#262525"
local modkey = "Mod4"

theme.font = "TerminessTTF Nerd Font 10"
theme.taglist_font = "RobotoMono Nerd Font 9"

theme.bg_normal = color_background
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = 6

-- theme.fg_normal     = "#aaaaaa"
theme.fg_normal = color_accent
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(0)
theme.border_width = dpi(2)
theme.border_color_normal = "#000000"
theme.border_color_active = color_accent
theme.border_color_marked = "#91231c"

theme.tasklist_align = "center"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
                                taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
                                  taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
-- theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path ..
                                         "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path ..
                                        "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path ..
                                            "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path ..
                                           "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path ..
                                                  "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path ..
                                                 "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path ..
                                                "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path ..
                                               "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path ..
                                                   "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path ..
                                                  "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path ..
                                                 "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path ..
                                                "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path ..
                                                     "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path ..
                                                    "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path ..
                                                   "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path ..
                                                  "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path ..
                                                      "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path ..
                                                     "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path ..
                                                    "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path ..
                                                   "default/titlebar/maximized_focus_active.png"

theme.wallpaper = "~/Wallpapers/995647.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height,
                                               theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule = {urgency = 'critical'},
        properties = {bg = '#ff0000', fg = '#ffffff'}
    }
end)

theme.battery_widget = {}
theme.language_widget = {}
theme.volume_widget = {}
theme.time_date_widget = {}
theme.connectivity_widget = {}

function theme.init_widgets()
    theme.battery_widget = basic_widgets.basic_battery()
    theme.language_widget = basic_widgets.basic_kb_layout()
    theme.volume_widget = basic_widgets.basic_volume()
    theme.time_date_widget = basic_widgets.basic_time_date()
    theme.connectivity_widget =
        basic_widgets.basic_connectivity({"enp59s0"}, -- =>
        {"wlp0s20f3"})
end

function theme.at_screen_connect(s)
    awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[2])
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    s.mylayoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end)
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({modkey}, 1, function(t)
                if client.focus then client.focus:move_to_tag(t) end
            end), awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({modkey}, 3, function(t)
                if client.focus then client.focus:toggle_tag(t) end
            end),
            awful.button({}, 4, function(t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function(t)
                awful.tag.viewnext(t.screen)
            end)
        }
    }

    -- Create a tasklist widget

    local tasks_list_buttons = {
        awful.button({}, 1, function(c)
            c:activate{context = "tasklist", action = "toggle_minimization"}
        end), awful.button({}, 3, function()
            awful.menu.client_list {theme = {width = 250}}
        end), awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
        awful.button({}, 5, function() awful.client.focus.byidx(1) end)
    }

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasks_list_buttons,
        layout = {
            spacing_widget = {
                {
                    forced_width = 5,
                    forced_height = 10,
                    thickness = 2,
                    widget = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place
            },
            spacing = 3,
            layout = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {id = 'clienticon', widget = awful.widget.clienticon},
                    left = 8,
                    right = 8,
                    top = 2,
                    bottom = 2,
                    widget = wibox.container.margin
                },
                id = 'background_role',
                widget = wibox.container.background
            },
            nil,
            create_callback = function(self, c, index, objects) -- luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s})

    -- Add widgets to the wibox
    s.mywibox.widget = {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            wibox.widget.systray(),
            theme.connectivity_widget.widget,
            -- connection_widget.widget,
            theme.volume_widget.widget,
            theme.battery_widget.widget,
            theme.language_widget.widget,
            theme.time_date_widget.widget
        }
    }
end

return theme

