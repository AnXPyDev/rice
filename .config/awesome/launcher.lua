launcher = SearchMenu:new()
  :setup({
  screen = screens.primary,
  wibox = {
    size = {dpi(300), dpi(500) --[[screens.primary.geometry.height - beautiful.wibar_height]]},
    pos = {screens.primary.geometry.x + dpi(10), screens.primary.geometry.y + beautiful.wibar_height + dpi(10)},
    shape = function(cr, w, h)
      return gears.shape.infobubble(cr, w, h, beautiful.corner_radius, dpi(10), beautiful.corner_radius + dpi(4))
    end
  },
  prompt = {
    halign = "center",
    outsideMargins = {
      top = dpi(20),
      left = dpi(10),
      bottom = dpi(5),
      right = dpi(10)
    }
  },
  elements = {
    size = {
      nil, dpi(40)
    },
    halign = "left",
    valign = "center",
    iconPosition = "left",
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/emacs.png")},
      {name = "Firefox", callback = function() awful.spawn("firefox") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/firefox.png")},
      {name = "Gimp", callback = function() awful.spawn("gimp") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/gimp.png")},
      {name = "Terminal", callback = function() awful.spawn("xst") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/terminal.png")},
      {name = "Minecraft", callback = function() awful.spawn.with_shell("java -jar ~/launcher.jar") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/minecraft.png")}
    }
  }
	})
