-- /keybordindicator.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--


keyboardindicator = {}

-- Initializes "keyboardindicator"

function keyboardindicator:setup()

	self.config = {}

	themer.apply(
		{
			{"fg", "#FFFFFF"},
			{{"bg", 1}, "#000000"},
			{{"bg", 2}, "#555555"},
			{{"blinkBg", 1}, "#AAAAAA"},
			{{"blinkBg", 2}, "#AAAAAA"},
      {"animate", false},
			{"blinkUpAmplitude", themeful.animate.blinkUpAmplitude or 0.5},
			{"blinkDownAmplitude", themeful.animate.blinkDownAmplitude or 0.5}
		},
		themeful.keyboardIndicator or {}, self.config
	)
	
	self.icon = materializeSurface(gears.surface.load(PATH.icons .. "keyboard.png"), {fg = self.config.fg})
	self.image = wibox.widget.imagebox(self.icon.fg)

	if self.config.animate then
		-- Color used for animating background
		self.animatedColor = rgbToArray(self.config.bg)
		-- Animation that blinks background when clicked on or updated
		self.colorAnimation = {}
	end

  self.config.patternTemplate = {
    from = {0,0},
    to = {themeful.statusBar.wibox.size[1] - extractMargin(themeful.statusBar.wibox.margins), 0}
  }
	
	self.widget = Showcase:new()
		:setup(
			{
				text = "bruh",
				showcase = self.image,
				halign = "left",
				bg = gears.color.create_linear_pattern(colorsToPattern(self.config.bg, self.config.patternTemplate)),
				fg = self.config.fg,
				showcasePosition = "left",
				size = {nil, dpi(40)},
				outsideMargins = margins(0),
				showcaseMargins = margins(0, dpi(10), 0)
			}
					)

	-- Cycles keyboard layouts on click
	self.widget.widget.final:connect_signal(
		"button::press", function()
			nextKbdLayout()
										 end
	)

	-- Updates self when initialized
	self:update()
end

-- Updates appearance of widget when layout changes

function keyboardindicator:update()
	-- Changes text of widet to name of current layout
	self.widget:reset(currentKbdLayout .. " " .. kbdlayouts[currentKbdLayout]:upper())

	if self.config.animate then
		-- Starts an animation which fades background to blink color and back
		self.colorAnimation.done = true
		self.colorAnimation.callback = function() end
		self.colorAnimation = animate.addRgbGradient({
			element = self.widget.widget.background,
			colors = self.animatedColor,
			targetColors = rgbToArray(self.config.blinkBg),
			amplitude = self.config.blinkUpAmplitude,
      template = self.config.patternTemplate,
			treshold = 0.01,
			callback = function()
				self.colorAnimation = animate.addRgbGradient({
					element = self.widget.widget.background,
					colors = self.animatedColor,
					targetColors = rgbToArray(self.config.bg),
					amplitude = self.config.blinkDownAmplitude,
          template = self.config.patternTemplate,
					treshold = 0.01
				})
			end
		})
	end
end

-- Initializes "keyboardindicator"

keyboardindicator:setup()
