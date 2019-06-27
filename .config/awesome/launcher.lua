launcher = SearchMenu:new()
  :setup({
  screen = screens.primary,
  wibox = {
    size = {dpi(300), screens.primary.geometry.height},
    pos = {screens.primary.geometry.x + 0, screens.primary.geometry.y + 0}
  },
  prompt = {
  },
  elements = {
    size = {
      nil, dpi(40)
    },
    halign = "left",
    valign = "center",
    iconPosition = "left",
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end, icon = gears.surface.load(PATH.home .. "icons/emacs.png")},
      {name = "Firefox", callback = function() awful.spawn("firefox") end, icon = gears.surface.load(PATH.home .. "icons/firefox.png")},
      {name = "Gimp", callback = function() awful.spawn("gimp") end, icon = gears.surface.load(PATH.home .. "icons/gimp.png")},
      {name = "Terminal", callback = function() awful.spawn("xst") end, icon = gears.surface.load(PATH.home .. "icons/terminal.png")}
    }
  }
	})
