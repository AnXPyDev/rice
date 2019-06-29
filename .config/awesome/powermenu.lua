local powermenuArgs = {
  searchDisabled = true,
  screen = screens.primary,
  wibox = {
    size = {dpi(100), dpi(300)},
    pos = {
      screens.primary.geometry.x + (screens.primary.geometry.width - dpi(100)),
      screens.primary.geometry.y + ((screens.primary.geometry.height - dpi(300)) / 2)
    },
    shape = function(cr, w, h)
      return gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, beautiful.corner_radius)
    end
  },
  prompt = {
    hide = true
  },
  elements = {
    size = {dpi(100), dpi(100)},
    halign = "center",
    valign = "center",
    iconPosition = "top",
    hideText = true,
    margins = {
      left = dpi(20),
      right = dpi(20),
      top = dpi(20),
      bottom = dpi(20)
    },
    outsideMargins = {
      left = dpi(10),
      right = dpi(10),
      top = dpi(10),
      bottom = dpi(10)
    },
    list = {
      {name = "Power Off", callback = function() awful.spawn.with_shell("poweroff") end, showcase =  wibox.widget.imagebox(PATH.home .. "icons/poweroff.png")},
      {name = "Reboot", callback = function() awful.spawn.with_shell("reboot") end, showcase =  wibox.widget.imagebox(PATH.home .. "icons/reboot.png")},
      {name = "Suspend", callback = function() awful.spawn.with_shell("systemctl suspend") end, showcase =  wibox.widget.imagebox(PATH.home .. "icons/suspend.png")}
    }
  }
}

powermenu = SearchMenu:new():setup(powermenuArgs)

powermenu.animationRunning = false

function powermenu.showAnimate()
  if not powermenu.animationRunning then
    powermenu.animationRunning = true
    animate.add({
      object = powermenu.wibox.widget,
      start = {
	powermenuArgs.wibox.pos[1] + powermenuArgs.wibox.size[1],
	powermenuArgs.wibox.pos[2]
      },
      target = {
	powermenuArgs.wibox.pos[1],
	powermenuArgs.wibox.pos[2]
      },
      type = "interpolate",
      magnitude = 0.3,
      amount = 5,
      callback = function()
	powermenu.animationRunning = false
	print("FFF")
      end
    })
  end
  powermenu:show()
end
