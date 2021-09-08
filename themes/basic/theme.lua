---------------------------
-- Default awesome theme --
---------------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local wibox = require("wibox")
local awful = require("awful")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme_config = require("themes/basic/config")
local basic_widgets = require("themes/basic/widgets")

local theme = {}

local modkey = "Mod4"

theme.font = "TerminessTTF Nerd Font 10"
theme.taglist_font = "RobotoMono Nerd Font 9"

theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = 6

theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(0)
theme.border_width = dpi(2)
theme.border_color_normal = "#000000"
theme.border_color_active = "#aaaaaa"
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
                                taglist_square_size, theme_config.color_accent)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
                                  taglist_square_size, theme_config.color_accent)

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

-- [[ ############ THEME CONFIG HERE ############ ]]
theme_config.config_theme(theme)

theme.battery_widget = {}
theme.language_widget = {}
theme.volume_widget = {}
theme.time_date_widget = {}
theme.connectivity_widget = {}
theme.clients_widget = {}
theme.cpu_widget = {}
theme.gpu_widget = {}
theme.memory_widget = {}

awful.keyboard.append_global_keybindings({
    awful.key({modkey}, "space", function() theme.language_widget.switch() end,
              {description = "switch keyboard layout", group = "custom"}),
    awful.key({modkey}, "w", function() awful.spawn("firefox") end,
              {description = "launch firefox", group = "custom"}),
    awful.key({modkey}, "f", function() awful.spawn("thunar") end,
              {description = "launch thunar", group = "custom"}),
    awful.key({}, "Print", function() awful.spawn("flameshot screen -c") end,
              {description = "take full screenshot", group = "custom"}),
    awful.key({"Shift"}, "Print", function() awful.spawn("flameshot gui") end,
              {description = "take custom screenshot", group = "custom"}),
    awful.key({modkey}, "s", function() awful.spawn("flameshot gui") end,
              {description = "take custom screenshot", group = "custom"})
})

local function get_screen_clients(s)
    local tag = s.selected_tag
    local all = 0
    local visable = 0
    for _, __ in ipairs(tag:clients()) do all = all + 1 end
    for _, __ in ipairs(s.clients) do visable = visable + 1 end
    return "[ " .. tostring(visable) .. " | " .. tostring(all) .. " ]"
end

function theme.init_widgets()
    theme.battery_widget = basic_widgets.basic_battery("BAT0")
    theme.language_widget = basic_widgets.basic_kb_layout({"us", "ar"})
    theme.volume_widget = basic_widgets.basic_volume()
    theme.time_date_widget = basic_widgets.basic_time_date()
    theme.cpu_widget = basic_widgets.basic_cpu_sensors()
    theme.gpu_widget = basic_widgets.basic_gpu_sensors()
    theme.memory_widget = basic_widgets.basic_memory()

    theme.connectivity_widget =
        basic_widgets.basic_connectivity({"enp59s0"}, -- =>
        {"wlp0s20f3"})

    theme.clients_widget.widget = wibox.widget.textbox()
    theme.clients_widget.refresh = function()
        theme.clients_widget.widget.text =
            get_screen_clients(awful.screen.focused())
    end

    local tags = awful.screen.focused().selected_tags

    for _, tag in ipairs(tags) do
        tag:connect_signal("request::select",
                           function() theme.clients_widget.refresh() end)
    end
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
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox
        },
        {
            layout = wibox.layout.align.horizontal,
            theme.clients_widget.widget,
            s.mytasklist,
            wibox.widget.textbox(" "),
            expand = "outside"
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            wibox.widget.textbox(" "),
            wibox.widget.systray(),
            theme.gpu_widget.widget,
            theme.cpu_widget.widget,
            theme.memory_widget.widget,
            theme.connectivity_widget.widget,
            theme.volume_widget.widget,
            theme.battery_widget.widget,
            theme.language_widget.widget,
            theme.time_date_widget.widget
        }
    }
end

function theme.refresh_widgets()
    theme.connectivity_widget.refresh()
    theme.battery_widget.refresh()
    theme.volume_widget.refresh()
    theme.clients_widget.refresh()
    theme.cpu_widget.refresh()
    theme.gpu_widget.refresh()
    theme.memory_widget.refresh()
end

return theme

