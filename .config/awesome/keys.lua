keys = {}

keys.mod = "Mod4"

keys.global = gears.table.join(
  awful.key({keys.mod}, "d", function() launcher.showAnimate() end),
  awful.key({keys.mod}, "q", function() powermenu.showAnimate() end),
  awful.key({keys.mod, "Shift"}, "r", awesome.restart),
  awful.key({keys.mod}, "n", function() awful.client.focus.global_bydirection("down") end),
  awful.key({keys.mod}, "p", function() awful.client.focus.global_bydirection("up") end),
  awful.key({keys.mod}, "b", function() awful.client.focus.global_bydirection("left") end),
  awful.key({keys.mod}, "f", function() awful.client.focus.global_bydirection("right") end),
  awful.key({keys.mod, "Shift"}, "n", function() awful.client.swap.global_bydirection("down") end),
  awful.key({keys.mod, "Shift"}, "p", function() awful.client.swap.global_bydirection("up") end),
  awful.key({keys.mod, "Shift"}, "b", function() awful.client.swap.global_bydirection("left") end),
  awful.key({keys.mod, "Shift"}, "f", function() awful.client.swap.global_bydirection("right") end),
  awful.key({keys.mod}, "v", function() awful.spawn.with_shell("pulsemixer --change-volume -5") end),
  awful.key({keys.mod, "Shift"}, "v", function() awful.spawn.with_shell("pulsemixer --change-volume +5") end),
  awful.key({keys.mod}, "m", function() awful.spawn.with_shell("pulsemixer --toggle-mute") end),
  awful.key({keys.mod}, "g", toggleGaps),
  awful.key({keys.mod}, "i", setWallpaper)
)

keys.client = gears.table.join(
  awful.key({keys.mod, "Shift"}, "q", function(c) c:kill() end),
  awful.key({keys.mod}, "s", function(c)
    c.floating = not c.floating
    c.ontop = c.floating
  end),
  awful.key({keys.mod}, "w", function(c)
    c.fullscreen = not c.fullscreen
  end)
)

for i = 1, #tags.list do
  keys.client = gears.table.join(keys.client, awful.key({keys.mod, "Shift"}, tostring(i), function(c)
    c:move_to_tag(tags.list[i])
    tagindicator:update()
  end))
  keys.global = gears.table.join(keys.global, awful.key({keys.mod}, tostring(i), function(c)
    tags.list[i]:view_only()
    tagindicator.showAnimate()
  end))
end


root.keys(keys.global)
