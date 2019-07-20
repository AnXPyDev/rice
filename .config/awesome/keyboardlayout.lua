-- /keyboardlayout.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--


kbdlayouts = {}

kbdlayouts["English"] = "us"
kbdlayouts["Slovak"] = "sk qwerty"
kbdlayouts["German"] = "de qwerty"

currentKbdLayout = "English"

awful.spawn.with_shell("setxkbmap " .. kbdlayouts[currentKbdLayout])

-- Cycles through defined keyboard layouts and updates "keyboardindicator"

function nextKbdLayout()
  local keys = gears.table.keys(kbdlayouts)
  local next = 1
  for i = 1, #keys do
    if keys[i] == currentKbdLayout then
      next = i + 1
    end
  end
  if next > #keys then
    next = 1
  end
  currentKbdLayout = keys[next]
  awful.spawn.with_shell("setxkbmap " .. kbdlayouts[currentKbdLayout])
	keyboardindicator:update()
end
