launcher = SearchMenu:new():setup({
  screen = screens.primary,
  size = {dpi(600), dpi(400)},
  offset = dpi(50),
  padding = dpi(10),
  elements = {
    {name = "Emacs", callback = function() awful.spawn("emacs") end},
    {name = "Firefox", callback = function() awful.spawn("firefox") end}
  }
				  })
