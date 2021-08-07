local wibox = require("wibox")
require("awful.autofocus")
local utils = require("utils")
local kb_layout_widget = require("./widgets/kb_layout_widget")
local volume_widget = require("./widgets/volume_widget")
local battery_widget = require("./widgets/battery_widget")
local time_date_widget = require("./widgets/time_date_widget")
local network_widget = require("./widgets/network_widget")
local util_scripts = require("util_scripts")
local theme = require("theme")

local space = " "
local widgets = {}

widgets.keyboard_layout = kb_layout_widget.basic
widgets.volume = volume_widget.basic
widgets.battery = battery_widget.basic
widgets.time_date = time_date_widget.basic
widgets.connection = network_widget.basic

return widgets
