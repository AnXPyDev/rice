-- /screen.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

screens = {}
screens.list = {}

-- Put each screen into a list and assign it a loadScreen

awful.screen.connect_for_each_screen(
  function(s)
    screens.list = gears.table.join(screens.list, {s})
		s.loadScreen = loadscreen:new():setup({screen = s})
		s.loadScreen:animate()
		s.director = director:new():setup({screen = s})
  end
)

-- Swap screens if there is two of them

if #screens.list == 2 then
	screens.list[1], screens.list[2] = screens.list[2], screens.list[1]
end

-- Set primary screen

screens.primary = screens.list[1]
screen.primary = screens.list[1]
