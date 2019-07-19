local powermenuIcons = {
	poweroff = materializeSurface(gears.surface.load(PATH.home .. "icons/poweroff.png")),
	reboot = materializeSurface(gears.surface.load(PATH.home .. "icons/reboot.png")),
	suspend = materializeSurface(gears.surface.load(PATH.home .. "icons/suspend.png")),
}

local powermenuImages = {
	poweroff = wibox.widget.imagebox(),
	reboot = wibox.widget.imagebox(),
	suspend = wibox.widget.imagebox()
}

local function makeBgFunction(name)
	return function(i, isSelected)
		if isSelected then
			powermenuImages[name].image = powermenuIcons[name].onPrimary
			return themeful.searchMenu.elements.bgHl
		else
			powermenuImages[name].image = powermenuIcons[name].onBackground
			return themeful.searchMenu.elements.bg
		end
	end
end

local powermenuArgs = {
  searchDisabled = true,
  screen = screens.primary,
  wibox = {
    size = {dpi(100), dpi(300)},
    pos = {
      screens.primary.geometry.x + (screens.primary.geometry.width - dpi(100)) - dpi(10),
      screens.primary.geometry.y + ((screens.primary.geometry.height - dpi(300)) / 2)
    },
  },
  prompt = {
    hide = true,
    size = {0,0}
  },
  elements = {
    size = {dpi(100), dpi(100)},
    halign = "center",
    valign = "center",
    iconPosition = "top",
    hideText = true,
		margins = margins(20),
		outsideMargins = margins(10),
		showcaseMargins = margins(0),
    list = {
      {name = "Power Off", callback = function() awful.spawn.with_shell("poweroff") end, showcase = powermenuImages.poweroff, bgFunc = makeBgFunction("poweroff")},
      {name = "Reboot", callback = function() awful.spawn.with_shell("reboot") end, showcase = powermenuImages.reboot, bgFunc = makeBgFunction("reboot")},
      {name = "Suspend", callback = function() awful.spawn.with_shell("systemctl suspend") end, showcase = powermenuImages.suspend, bgFunc = makeBgFunction("suspend")}
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
