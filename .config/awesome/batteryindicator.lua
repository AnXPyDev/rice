batteryindicator = {}

function batteryindicator:setup(args)
	self.widget = Showcase:new()
		:setup(
			{
				showcase = wibox.widget.imagebox(PATH.home .. "icons/battery.png"),
				disableText = true,
				size = {nil, dpi(50)},
				outsideMargins = margins(0, nil, dpi(10)),
				halign = "left",
				showcaseMargins = margins(0, dpi(10), 0)
			}
					)
end

batteryindicator:setup(args)
