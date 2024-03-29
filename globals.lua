local awful                              = require("awful")
local xresources                         = require("beautiful.xresources")
local naughty                            = require("naughty")

local globals                            = {}

globals.font                             = {}
globals.font.size                        = 10
globals.font.name                        = "Caskaydia Cove Nerd Font"
globals.font.theme                       = globals.font.name .. " " .. globals.font.size
globals.font.full_modified               = function(size)
    return globals.font.name .. " " .. globals.font.size + size
end

globals.dimensions                       = {}
globals.dimensions.gap_size              = 4
globals.dimensions.border_width          = 4
globals.dimensions.top_bar_height        = 28

globals.dimensions.spacing               = {}
globals.dimensions.spacing.tags          = 0
globals.dimensions.spacing.tasks         = 0
globals.dimensions.spacing.notifications = 0

globals.dimensions.corners_radius        = 0
globals.dimensions.margin                = 4

globals.limits                           = {}
globals.limits.cpu_temp                  = 80
globals.limits.ram_percent               = 80
globals.limits.gpu_temp                  = 70
globals.limits.download_speed            = 800 * 1024

globals.colors                           = {
    crimson = "#c54b6c",
    turquoise = "#b6d8f2",
    tonys_pink = "#e6a57e",
    pink = "#eb96aa",
    steel_blue = "#4382bb",
    burly_wood = "#e7cba9",
    salmon = "#f9968b",
    sienna = "#874741",
    your_pink = "#FEc7bc",
    green = "#77c077",
    orangish = "#f27348",
    purplish = "#dc828f",
    gold = "#90cdc3",
    light_gray = "#dbbc8e",
    light_green = "#2cced2",
    chatelle = "#ff815e",
    purple = "#b28dff",
    success = "#77c077",
    error = "#dc143c",
    background = "#222222",
    on_background = "#ffffff",
    white = "#ffffff"
}
globals.colors.alpha                     = "a8" -- Hex value
globals.colors.wallpaper_tint_alpha      = "20" -- Hex value

globals.tags                             = {
    {
        name = "dev",
        icon = "󰀴",
        color = globals.colors.green,
        color_ontop = globals.colors.white
    },
    {
        name = "web",
        icon = "󰈹",
        color = globals.colors.orangish,
        color_ontop = globals.colors.white
    },
    {
        name = "files",
        icon = "󰉋",
        color = globals.colors.purple,
        color_ontop = globals.colors.white
    },
    {
        name = "media",
        icon = "󰈸",
        color = globals.colors.crimson,
        color_ontop = globals.colors.white
    },
    {
        name = "term",
        icon = "",
        color = globals.colors.steel_blue,
        color_ontop = globals.colors.white
    },
}


globals.tags.current = function()
    local current = globals.tags[awful.screen.focused().selected_tag]

    if current ~= nil then
        current = globals.tags[awful.screen.focused().selected_tag.index]
    else
        current = globals.tags[1]
    end

    return current
end


function Debug_notification(something)
    naughty.notify({ text = tostring(something) })
end

function utf8.sub(s, i, j)
    i = utf8.offset(s, i)
    j = utf8.offset(s, j + 1) - 1
    return string.sub(s, i, j)
end

return globals
