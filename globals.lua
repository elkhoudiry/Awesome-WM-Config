local xresources                  = require("beautiful.xresources")

local globals                     = {}

globals.font                      = {}
globals.font.size                 = 10
globals.font.name                 = "Caskaydia Cove Nerd Font"
globals.font.theme                = globals.font.name .. " " .. globals.font.size
globals.font.full_modified        = function(size)
    return globals.font.name .. " " .. globals.font.size + size
end

globals.dimensions                = {}
globals.dimensions.gap_size       = xresources.apply_dpi(4)
globals.dimensions.border_width   = xresources.apply_dpi(3)
globals.dimensions.top_bar_height = 34

globals.colors                    = {
    crimson = "#dc143c",
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
    background = "#222222",
    white = "#ffffff"
}

globals.tags                      = {
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
        color = globals.colors.salmon,
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

return globals
