batteryindicator = {}

function batteryindicator:startRefresh()
	awful.spawn.easy_async("bash " .. PATH.config .. "grabbattery.bash",
		function(stdout, stderr, exitreason, exitcode)
			self:refresh(stdout)
			self.refreshTimer:again()
		end
	)
end

function batteryindicator:refresh(output)
	output = gears.string.split(output, "\n")
	if output[1] == "noBattery" then
		self.isBattery = false
		self.percentage = 100
	else
		self.isBattery = true
		self.percentage = tonumber(output[1])
		self.state = output[2]
	end
	print(self.showcase.value)
end

function batteryindicator:setup(args)
	self.isBattery = true
	self.percentage = 0
	self.refreshInterval = 3
	self.images = {
		depleting = wibox.widget.imagebox(PATH.home .. "icons/battery_depleting.png"),
		charging = wibox.widget.imagebox(PATH.home .. "icons/battery_charging.png"),
		charged = wibox.widget.imagebox(PATH.home .. "icons/battery_charged.png")
	}
	self.showcase = wibox.widget.progressbar()
	animate.addBare(
		{
			callback = nil,
			updateLoop = function()
				print(wave(0,1, 10000))
				return false
			end
		}
	)
	self.widget = Showcase:new()
		:setup(
			{
				showcase = self.showcase,
				text = "Battery",
				disableText = false,
				size = {nil, dpi(75)},
				outsideMargins = margins(0, nil, dpi(10), 0),
				halign = "left",
				showcaseMargins = margins(0, dpi(10), 0),
				showcasePosition = "left",
			}
					)
						
	self.refreshTimer = gears.timer {
		autostart = false,
		timeout = self.refreshInterval,
		single_shot = true,
		call_now = true,
		callback = function()
			self:startRefresh()
		end
	}
end

batteryindicator:setup(args)
