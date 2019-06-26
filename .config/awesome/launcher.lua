launcher = SearchMenu:new()
  :setup({
  screen = screens.primary,
  wibox = {
    size = {dpi(500), screens.primary.geometry.height},
    pos = {0, 0}
  },
  prompt = {},
  elements = {
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end},
      {name = "Firefox", callback = function() awful.spawn("firefox") end}
    }
  }
	})
