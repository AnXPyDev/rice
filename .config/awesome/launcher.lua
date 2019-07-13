local launcherArgs = {
  screen = screens.primary,
  wibox = {
    size = {dpi(500), dpi(300)},
    pos = {screens.primary.geometry.x + (screens.primary.geometry.width - dpi(500)) / 2, screens.primary.geometry.y + (screens.primary.geometry.height - dpi(400)) / 2},
    shape = gears.shape.fixed_rounded_rect
  },
  prompt = {
    shape = gears.shape.rectangle,
    outsideMargins = margins(0),
    margins = margins(dpi(20), nil, 0, 0),
    size = {
      nil, dpi(60)
    },
    halign = "left",
  },
  elements = {
    shape = gears.shape.fixed_rounded_rect,
    outsideMargins = margins(dpi(10)),
    showcaseMargins = margins(dpi(10)),
    margins = margins(dpi(10)),
    size = {
      dpi(100), dpi(120)
    },
    halign = "center",
    valign = "center",
    showcasePosition = "top",
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/emacs.png")},
      {name = "Firefox", callback = function() awful.spawn("firefox") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/firefox.png")},
      {name = "Gimp", callback = function() awful.spawn("gimp") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/gimp.png")},
      {name = "Terminal", callback = function() awful.spawn("xst") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/terminal.png")},
      {name = "Minecraft", callback = function() awful.spawn.with_shell("java -jar ~/launcher.jar") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/minecraft.png")},
      {name = "Team Speak", callback = function() awful.spawn("teamspeak3") end, showcase = wibox.widget.imagebox(PATH.home .. "icons/teamspeak3.png")}
    }
  }
}

launcher = SearchMenu:new():setup(launcherArgs)

launcher.animationRunning = false

function launcher.showAnimate()
  if not launcher.animationRunning then
    launcher.animationRunning = true
    animate.add({
      object = launcher.wibox.widget,
      start = {
	launcherArgs.wibox.pos[1],
	launcherArgs.wibox.pos[2] - (launcherArgs.wibox.size[2])
      },
      target = {
	launcherArgs.wibox.pos[1],
	launcherArgs.wibox.pos[2]
      },
      type = "interpolate",
      magnitude = 0.3,
      amount = 5,
      callback = function()
	launcher.animationRunning = false
      end
    })
  end
  launcher:show()
end

