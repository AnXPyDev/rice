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
  modules = os.getenv("HOME") .. "/.config/awesome/modules/",
	statusbar = os.getenv("HOME") .. "/.config/awesome/statusbar/",
	icons = os.getenv("HOME") .. "/.config/awesome/icons/"
}

themeful = {}
colorful = {}
theme = {}

local availableColorshemes = {
	dark = {"anaglyph", "ephermal"},
	light = {"anaglyph", "vaporwave"}
}

local colorschemeCategory = "dark"
local colorschemeNames = {"anaglyph", "base"}
local themeNames = {"material"}

PATH.wallpapers = os.getenv("HOME") .. "/.config/awesome/wallpapers/" .. colorschemeCategory .. "/"
PATH.colorscheme = os.getenv("HOME") .. "/.config/awesome/colorschemes/" .. colorschemeCategory .. "/"

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

dofile(PATH.config .. "wallpaper.lua")
dofile(PATH.config .. "screen.lua")

for i, name in ipairs(themeNames) do
	dofile(PATH.theme .. name .. ".lua")
end

for i, name in ipairs(colorschemeNames) do
	dofile(PATH.colorscheme .. name .. ".lua")
end

beautiful.init(theme)

-- Animate loadscreen for each screen

awful.screen.connect_for_each_screen(
  function(s)
		s.loadScreen = loadscreen:new():setup({screen = s})
		s.loadScreen:animate()
		s.director = director:new():setup({screen = s})
  end
)

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
