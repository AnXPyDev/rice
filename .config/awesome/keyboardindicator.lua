keyboardindicator = {}

function keyboardindicator:setup()
	self.icon = materializeSurface(gears.surface.load(PATH.home .. "icons/keyboard.png"))
	self.image = wibox.widget.imagebox(self.icon.onComplementary)
	self.color = colors.new(colorful.complementary)
	self.colorAnimation = {}
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
	self.widget.widget.final:connect_signal(
		"button::press", function()
			nextKbdLayout()
										 end
	)

	self:update()
end

function keyboardindicator:update()
	self.colorAnimation.done = true
	self.colorAnimation.callback = function() end
	self.widget:reset(currentKbdLayout .. " " .. kbdlayouts[currentKbdLayout]:upper())
	self.colorAnimation = animate.addColor({
		element = self.widget.widget.background,
		color = self.color,
		targetColor = colors.new(colorful.complementaryShades[4]),
		amplitude = 0.3,
		treshold = 0.01,
		callback = function()
			self.colorAnimation = animate.addColor({
				element = self.widget.widget.background,
				color = self.color,
				targetColor = colors.new(colorful.complementary),
				amplitude = 0.2,
				treshold = 0.01
			})
		end
	})
end

keyboardindicator:setup()
