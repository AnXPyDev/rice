launcher = SearchMenu:new()
  :setup({
  screen = screens.primary,
  wibox = {
    size = {dpi(500), dpi(300)},
    offset = 20
  },
  prompt = {},
  elements = {
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end},
      {name = "Firefox", callback = function() awful.spawn("firefox") end}
    }
  }
	})
