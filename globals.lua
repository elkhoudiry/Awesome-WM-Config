local globals = {}

globals.font = {}
globals.font.size = 10
globals.font.name = "Caskaydia Cove Nerd Font"
globals.font.theme = globals.font.name .. " " .. globals.font.size
globals.font.full_modified = function(size)
    return globals.font.name .. " " .. globals.font.size + size
end

globals.colors = {
    crimson = "#dc143c",
    turquoise = "#b6d8f2",
    tonys_pink = "#e6a57e",
    pink = "#eb96aa",
    steel_blue = "#4382bb",
    burly_wood = "#e7cba9",
    salmon = "#f9968b",
    sienna = "#874741",
    your_pink = "#FEc7bc",
    sea_green = "#218b82",
    orangish = "#f27348",
    white = "#ffffff"
}

globals.tags = {
    {
        name = "dev",
        icon = "󰀴",
        color = globals.colors.sea_green,
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
