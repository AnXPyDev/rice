launcher = SearchMenu:new()
  :setup({
  screen = screens.primary,
  wibox = {
    size = {dpi(500), screens.primary.geometry.height},
    pos = {0, 0}
  },
  prompt = {
    text = "run: ",
    halign = "left"
  },
  elements = {
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end},
      {name = "Firefox", callback = function() awful.spawn("firefox") end},
      {name = "Gimp", callback = function() awful.spawn("gimp") end},
      {name = "Terminal", callback = function() awful.spawn("xst") end}
    }
  }
	})
