keyboardindicator = {}

function keyboardindicator:setup()
	self.icon = materializeSurface(gears.surface.load(PATH.home .. "icons/keyboard.png"))
	self.image = wibox.widget.imagebox(self.icon.onComplementary)
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
	self.widget:reset(currentKbdLayout .. " " .. kbdlayouts[currentKbdLayout]:upper())
end

keyboardindicator:setup()
