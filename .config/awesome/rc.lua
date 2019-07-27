-- Libraries
awful = require("awful")
gears = require("gears")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
xresources = require("beautiful.xresources")
stringdistance = require("stringdistance")
dpi = xresources.apply_dpi
dpi = function(x)
  return x
end

require("awful.autofocus")

PATH = {
  home = os.getenv("HOME") .. "/",
  config = os.getenv("HOME") .. "/.config/awesome/",
  theme = os.getenv("HOME") .. "/.config/awesome/themes/",
  colorscheme = os.getenv("HOME") .. "/.config/awesome/colorschemes/",
  modules = os.getenv("HOME") .. "/.config/awesome/modules/",
	statusbar = os.getenv("HOME") .. "/.config/awesome/statusbar/",
	icons = os.getenv("HOME") .. "/.config/awesome/icons/"
}

themeful = {}
colorful = {}
theme = {}

local colorschemeName = "dark"
local themeName = "material"

PATH.wallpapers = os.getenv("HOME") .. "/.config/awesome/wallpapers/" .. colorschemeName .. "/"

-- Modules
colors = dofile(PATH.modules .. "colors.lua")
dofile(PATH.modules .. "editdistance.lua")
dofile(PATH.modules .. "sort.lua")
dofile(PATH.modules .. "math.lua")
dofile(PATH.modules .. "util.lua")
dofile(PATH.modules .. "themer.lua")
dofile(PATH.modules .. "animate.lua")
dofile(PATH.modules .. "director.lua")
dofile(PATH.modules .. "searchmenu.lua")
dofile(PATH.modules .. "slider.lua")
dofile(PATH.modules .. "showcase.lua")
dofile(PATH.modules .. "loadscreen.lua")
dofile(PATH.modules .. "button.lua")
dofile(PATH.modules .. "ynprompt.lua")

dofile(PATH.theme .. themeName .. ".lua")
dofile(PATH.colorscheme .. colorschemeName .. ".lua")

beautiful.init(theme)

dofile(PATH.config .. "wallpaper.lua")
dofile(PATH.config .. "screen.lua")

dofile(PATH.config .. "layout.lua")
dofile(PATH.config .. "tags.lua")
dofile(PATH.config .. "gaps.lua")
dofile(PATH.config .. "tagindicator.lua")
dofile(PATH.config .. "volumeslider.lua")
dofile(PATH.config .. "launcher.lua")
dofile(PATH.config .. "powermenu.lua")
dofile(PATH.config .. "keyboardlayout.lua")

dofile(PATH.statusbar .. "timeindicator.lua")
dofile(PATH.statusbar .. "internetindicator.lua")
dofile(PATH.statusbar .. "batteryindicator.lua")
dofile(PATH.statusbar .. "sysgraph.lua")
dofile(PATH.statusbar .. "keyboardindicator.lua")
dofile(PATH.statusbar .. "statusbuttons.lua")
dofile(PATH.statusbar .. "statusbar.lua")

dofile(PATH.config .. "keys.lua")
dofile(PATH.config .. "buttons.lua")
dofile(PATH.config .. "client.lua")
dofile(PATH.config .. "rules.lua")
dofile(PATH.config .. "wibar.lua")

setWallpaper()


-- Kill compton and restart it
awful.spawn.with_shell("killall compton; compton --config ~/.config/compton.conf")
-- Load Xresources
awful.spawn.with_shell("xrdb ~/.Xresources")

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oopsie doopsie",
    text = awesome.startup_errors
  })
end
