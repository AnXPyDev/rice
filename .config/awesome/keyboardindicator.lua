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
			{"bg", "#000000"},
			{"blinkBg", "#AAAAAA"},
			{"animate", false}
		},
		themeful.keyboardIndicator or {}, self.config
	)
	
	self.icon = materializeSurface(gears.surface.load(PATH.home .. "icons/keyboard.png"))
	self.image = wibox.widget.imagebox(self.icon.onComplementary)

	if self.config.animate then
		-- Color used for animating background
		self.backgroundColor = colors.new(colorful.complementary)
		-- Animation that blinks background when clicked on or updated
		self.backgroundAnimation = {}
	end
	
	self.widget = Showcase:new()
		:setup(
			{
				text = "bruh",
				showcase = self.image,
				halign = "left",
				bg = colorful.complementary,
				fg = colorful.onComplementary,
				showcasePosition = "left",
				size = {nil, dpi(50)},
				outsideMargins = margins(0, nil, dpi(10), 0),
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
		self.backgroundAnimation.done = true
		self.backgroundAnimation.callback = function() end
		self.backgroundAnimation = animate.addColor({
			element = self.widget.widget.background,
			color = self.backgroundColor,
			targetColor = colors.new(self.config.blinkBg),
			amplitude = 0.3,
			treshold = 0.01,
			callback = function()
				self.colorAnimation = animate.addColor({
					element = self.widget.widget.background,
					color = self.color,
					targetColor = colors.new(self.config.bg),
					amplitude = 0.2,
					treshold = 0.01
				})
			end
		})
	end
end

-- Initializes "keyboardindicator"

keyboardindicator:setup()
