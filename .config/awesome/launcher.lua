launcher = SearchMenu:new()
  :setup({
  screen = screens.primary,
  wibox = {
    size = {dpi(300), screens.primary.geometry.height},
    pos = {0, 0}
  },
  prompt = {},
  elements = {
    size = {
      nil, nil
    },
    halign = "center",
    valign = "bottom",
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end, icon = gears.surface.load(PATH.home .. "icons/emacs.png")},
      {name = "Firefox", callback = function() awful.spawn("firefox") end},
      {name = "Gimp", callback = function() awful.spawn("gimp") end},
      {name = "Terminal", callback = function() awful.spawn("xst") end},
      {name = "Suspend", callback = function() awful.spawn.with_shell("systemctl suspend") end}
    }
  }
	})
