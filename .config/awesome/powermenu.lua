-- /powermenu.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--


local powermenuConfig = {}
themer.apply(
  {
    {"wiboxSize", {nil,nil}},
    {"elementSize", {dpi(130), dpi(120)}},
    {"elementCount", {5,2}},
    {"boundedMargins", margins(0)},
    {{"elementBg", 1}, "#000000"},
    {{"elementBg", 2}, "#000000"},
    {"elementFg", "#FFFFFF"},
    {{"elementBgHl", 1}, "#FFFFFF"},
    {{"elementBgHl", 2}, "#FFFFFF"},
    {"elementFgHl", "#000000"},
    {{"wiboxBg", 1}, "#000000"},
    {{"wiboxBg", 2}, "#000000"},
    {"wiboxShape", gears.shape.rectangle},
    {"elementOutsideMargins", margins(0)},
    {"elementMargins", margins(dpi(10))},
    {"elementShowcaseMargins", margins(dpi(5))},
    {"elementShape", gears.shape.rectangle},
    {"halign", "center"},
    {"valign", "center"},
    {"showcasePosition", "top"},
    {"boundedValign", "center"},
    {"boundedHalign", "center"},
    {"animate", false}
  },
  themeful.powerMenu or {}, powermenuConfig
)

logTable(powermenuConfig)

-- Icons used by powermenu

local iconColors = {
  normal = powermenuConfig.elementFg,
  highlight = powermenuConfig.elementFgHl
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
  screen = screens.primary,
  wibox = {
    size = {},
    bg = powermenuConfig.wiboxBg,
    shape = powermenuConfig.wiboxShape
  },
  prompt = {
    hide = true
  },
  elements = {
    bg = powermenuConfig.elementBg,
    fg = powermenuConfig.elementFg,
    bgHl = powermenuConfig.elementBgHl,
    fgHl = powermenuConfig.elementFgHl,
    size = powermenuConfig.elementSize,
		outsideMargins = powermenuConfig.elementOutsideMargins,
		margins = powermenuConfig.elementMargins,
		boundedMargins = powermenuConfig.boundedMargins,
    showcaseMargins = powermenuConfig.elementShowcaseMargins,
		hideText = true,
    halign = powermenuConfig.halign,
    valign = powermenuConfig.valign,
    showcasePosition = powermenuConfig.showcasePosition,
    shape = powermenuConfig.elementShape,
    boundedValign = powermenuConfig.boundedValign,
    boundedHalign = powermenuConfig.boundedHalign,
    animate = powermenuConfig.animate,

    list = {
      {name = "Power Off", callback = function() awful.spawn.with_shell("poweroff") end, showcase = powermenuImages.poweroff, update = makeUpdateFunction("poweroff")},
      {name = "Reboot", callback = function() awful.spawn.with_shell("reboot") end, showcase = powermenuImages.reboot, update = makeUpdateFunction("reboot")},
      {name = "Suspend", callback = function() awful.spawn.with_shell("systemctl suspend") end, showcase = powermenuImages.suspend, update = makeUpdateFunction("suspend")},
      {name = "Log Out", callback = function() awesome.quit() end, showcase = powermenuImages.logout, update = makeUpdateFunction("logout")}
    }
  }
}


powermenuArgs.wibox.size[1] = powermenuConfig.wiboxSize[1] or powermenuConfig.elementCount[1] * powermenuArgs.elements.size[1] + powermenuArgs.elements.boundedMargins.left + powermenuArgs.elements.boundedMargins.right
powermenuArgs.wibox.size[2] = powermenuConfig.wiboxSize[2] or powermenuConfig.elementCount[2] * powermenuArgs.elements.size[2] + powermenuArgs.elements.boundedMargins.top + powermenuArgs.elements.boundedMargins.bottom

logTable(powermenuArgs)

--powermenuArgs.wibox.pos = {screens.primary.geometry.x + (screens.primary.geometry.width - powermenuArgs.wibox.size[1]) / 2, screens.primary.geometry.y + (screens.primary.geometry.height - powermenuArgs.wibox.size[2]) / 2}

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
