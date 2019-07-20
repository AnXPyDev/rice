-- /keys.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

keys = {}

-- Set mod to Super/Windows :) key
keys.mod = "Mod4"

-- Global keys, most of these are self-documenting
keys.global = gears.table.join(
  awful.key({keys.mod}, "d", function() launcher.showAnimate() end),
  awful.key({keys.mod}, "q", function() powermenu.showAnimate() end),
  awful.key({keys.mod}, "w", function() statusbar:show() end),
  awful.key({keys.mod}, "t", function() nextKbdLayout() end),
  awful.key({keys.mod}, "u", function() loadScreensAnimate() end),
  awful.key({keys.mod, "Shift"}, "r", awesome.restart),
  awful.key({keys.mod}, "Return", function() awful.spawn("xst") end),
  awful.key({keys.mod}, "n", function() awful.client.focus.global_bydirection("down") end),
  awful.key({keys.mod}, "p", function() awful.client.focus.global_bydirection("up") end),
  awful.key({keys.mod}, "b", function() awful.client.focus.global_bydirection("left") end),
  awful.key({keys.mod}, "o", function() awful.client.focus.global_bydirection("right") end),
  awful.key({keys.mod}, "Tab", function() awful.client.focus.byidx(1) end),
  awful.key({keys.mod, "Shift"}, "n", function() awful.client.swap.global_bydirection("down") end),
  awful.key({keys.mod, "Shift"}, "p", function() awful.client.swap.global_bydirection("up") end),
  awful.key({keys.mod, "Shift"}, "b", function() awful.client.swap.global_bydirection("left") end),
  awful.key({keys.mod, "Shift"}, "o", function() awful.client.swap.global_bydirection("right") end),
  awful.key({keys.mod}, "v", function() volumecontrol:change(-1) end),
  awful.key({keys.mod, "Shift"}, "v", function() volumecontrol:change(1) end),
  awful.key({keys.mod}, "m", function() volumecontrol:toggleMute() end),
  awful.key({keys.mod}, "g", toggleGaps),
  awful.key({keys.mod}, "i", setWallpaper),
	-- Resize client when tiled
  awful.key({keys.mod, "Control"}, "b", function() awful.tag.incmwfact(-0.02, nil) end),
  awful.key({keys.mod, "Control"}, "o", function() awful.tag.incmwfact(0.02, nil) end),
  awful.key({keys.mod, "Control"}, "p", function() awful.client.incwfact(-0.02) end),
  awful.key({keys.mod, "Control"}, "n", function() awful.client.incwfact(0.02) end)

)

-- Keys applied to clients
keys.client = gears.table.join(
  awful.key({keys.mod, "Shift"}, "q", function(c) c:kill() end),

	-- Toggles floating

  awful.key({keys.mod}, "s", function(c)
    c.floating = not c.floating
    c.ontop = c.floating
  end),

	-- Toggles fullscreen

  awful.key({keys.mod}, "f", function(c)
    c.fullscreen = not c.fullscreen
  end)
)

-- Keys that focus tags and move clients to them
for i = 1, #tags.list do
  keys.client = gears.table.join(keys.client, awful.key({keys.mod, "Shift"}, tostring(i), function(c)
    c:move_to_tag(tags.list[i])
    tagindicator:update()
  end))
  keys.global = gears.table.join(keys.global, awful.key({keys.mod}, tostring(i), function(c)
    tags.select(i)
		-- Updates "tagindicator"
    tagindicator.showAnimate()
  end))
end

-- Applies global keys
root.keys(keys.global)
