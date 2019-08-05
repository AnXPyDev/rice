-- /powermenu.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

-- Icons used by powermenu

local iconColors = {
  normal = themeful.searchMenu.elements.fg,
  highlight = themeful.searchMenu.elements.fgHl
}

local powermenuIcons = {
	poweroff = materializeSurface(gears.surface.load(PATH.icons .. "poweroff.png"), iconColors),
	reboot = materializeSurface(gears.surface.load(PATH.icons .. "reboot.png"), iconColors),
	suspend = materializeSurface(gears.surface.load(PATH.icons .. "suspend.png"), iconColors),
	logout = materializeSurface(gears.surface.load(PATH.icons .. "logout.png"), iconColors)
}

-- Images that hold the icons, so they can be changed later

local powermenuImages = {
	poweroff = wibox.widget.imagebox(),
	reboot = wibox.widget.imagebox(),
	suspend = wibox.widget.imagebox(),
	logout = wibox.widget.imagebox()
}

-- Function that changes icon colors to match background

local function makeUpdateFunction(name)
	return function(i, isSelected)
		if isSelected then
			powermenuImages[name].image = powermenuIcons[name].highlight
		else
			powermenuImages[name].image = powermenuIcons[name].normal
		end
	end
end

-- Arguments for SearchMenu

local powermenuArgs = {
  searchDisabled = false,
  screen = screens.primary,
  wibox = {
    size = {dpi(100), dpi(90) * 4 + dpi(10)},
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
		boundedMargins = margins(dpi(5)),
    size = {dpi(90), dpi(90)},
    halign = "center",
    valign = "center",
		showcasePosition = "top",
    hideText = true,
		margins = margins(dpi(20)),
		outsideMargins = margins(dpi(5)),
		showcaseMargins = margins(0),
    list = {
      {name = "Power Off", callback = function() awful.spawn.with_shell("poweroff") end, showcase = powermenuImages.poweroff, update = makeUpdateFunction("poweroff")},
      {name = "Reboot", callback = function() awful.spawn.with_shell("reboot") end, showcase = powermenuImages.reboot, update = makeUpdateFunction("reboot")},
      {name = "Suspend", callback = function() awful.spawn.with_shell("systemctl suspend") end, showcase = powermenuImages.suspend, update = makeUpdateFunction("suspend")},
      {name = "Log Out", callback = function() awesome.quit() end, showcase = powermenuImages.logout, update = makeUpdateFunction("logout")}
    }
  }
}

-- Creates powermenu
powermenu = SearchMenu:new():setup(powermenuArgs)

powermenu.directedBox = {}

-- Animates powermenu to slide in from right

function powermenu:hide()
	self.wibox.widget.visible = false
	self.screen.director:remove(self.directedBox)
end

function powermenu:showAnimate()
  if not self.wibox.widget.visible then
		self.directedBox = self.screen.director:add({
			side = "right",
			priority = 5,
			padding = themeful.outsideMargins,
			wibox = self.wibox.widget
		})
  end
  powermenu:show()
end
