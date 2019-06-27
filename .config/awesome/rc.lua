awful = require("awful")
gears = require("gears")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
xresources = require("beautiful.xresources")
stringdistance = require("stringdistance")
dpi = xresources.apply_dpi

require("awful.autofocus")

PATH = {
  home = os.getenv("HOME") .. "/",
  config = os.getenv("HOME") .. "/.config/awesome/",
  theme = os.getenv("HOME") .. "/.config/awesome/themes/",
  modules = os.getenv("HOME") .. "/.config/awesome/modules/"
}

function log(...)
  local arg = {...}
 local result = ""
  for i = 1, #arg do
    result = result .. " " .. tostring(arg[i])
  end
  naughty.notify({text = result:sub(2)})
  return arg[1]
end

local themeName = "default"

dofile(PATH.modules .. "editdistance.lua")
dofile(PATH.modules .. "sort.lua")
dofile(PATH.modules .. "math.lua")
dofile(PATH.modules .. "searchmenu.lua")

dofile(PATH.theme .. themeName .. ".lua")

dofile(PATH.config .. "wallpaper.lua")
dofile(PATH.config .. "screen.lua")
dofile(PATH.config .. "layout.lua")
dofile(PATH.config .. "tags.lua")
dofile(PATH.config .. "gaps.lua")
dofile(PATH.config .. "tagindicator.lua")
dofile(PATH.config .. "launcher.lua")
dofile(PATH.config .. "keys.lua")
dofile(PATH.config .. "buttons.lua")
dofile(PATH.config .. "client.lua")
dofile(PATH.config .. "rules.lua")

-- Kill compton and restart it
--awful.spawn.with_shell("killall compton; compton --config ~/.config/compton.conf")


if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oopsie doopsie",
    text = awesome.startup_errors
  })
end
