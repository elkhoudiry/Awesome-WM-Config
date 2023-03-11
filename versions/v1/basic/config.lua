local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local config = {}

config.main_font = "Caskaydia Cove Nerd Font 10"
config.tags_list_font = "Caskaydia Cove Nerd Font 10"
config.color_pink = "#F8708C"
config.color_gray = "#262525"
config.color_lime = "#C3EB78"
config.color_red = "#cc0000"
config.color_caramel = "#f8dc93"
config.color_indian_yellow = "#e8a05d"

config.color_accent = config.color_lime
config.color_background = config.color_gray

function config.config_theme(theme)
    theme.font = config.tags_list_font
    theme.taglist_font = config.tags_list_font

    theme.useless_gap = dpi(0)

    theme.fg_normal = config.color_accent
    theme.bg_normal = config.color_background
    theme.border_color_active = config.color_accent
    theme.wallpaper = "~/Wallpapers/AOT.png"
    theme.icon_theme = "~/.icons/Qogir-manjaro-normal"
end

return config
