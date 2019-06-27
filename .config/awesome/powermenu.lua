powermenu = SearchMenu:new()
  :setup({
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
	{name = "Power Off", callback = function() awful.spawn.with_shell("poweroff") end, icon = gears.surface.load(PATH.home .. "icons/poweroff.png")},
	{name = "Reboot", callback = function() awful.spawn.with_shell("reboot") end, icon = gears.surface.load(PATH.home .. "icons/reboot.png")},
	{name = "Suspend", callback = function() awful.spawn.with_shell("systemctl suspend") end, icon = gears.surface.load(PATH.home .. "icons/suspend.png")}
      }
    }
	})
