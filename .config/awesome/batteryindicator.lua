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
	local lastState = self.state
	if output[1] == "noBattery" then
		self.isBattery = false
		self.percentage = 100
		self.animation.paused = true
		self.progressbar.value = self.percentage / 100
		self.imageMargin.widget.image = self.images.charged.onBackground
	else
		if self.state == "charging" then
			self.imageMargin.widget.image = self.images.charging.onBackground
			self.animation.paused = false
		elseif self.state == "depleting" then
			self.imageMargin.widget.image = self.images.depleting.onBackground
			self.animation.paused = true
			self.progressbar.value = self.percentage / 100
		elseif self.state == "charged" then
			self.imageMargin.widget.image = self.images.charged.onBackground
			self.animation.paused = true
			self.progressbar.value = self.percentage / 100
		end
		self.isBattery = true
		self.percentage = tonumber(output[1])
		self.state = output[2]
	end
end

function batteryindicator:makeWidget()
	self.progressbar = wibox.widget.progressbar()
	self.progressbar.shape = themeful.shape
	self.progressbar.color = colorful.primary
	self.progressbar.background_color = colorful.primaryShades[10]
	self.imageMargin = wibox.container.margin()
	gears.table.crush(self.imageMargin, margins(0, dpi(10), 0))
	self.widgets = wibox.widget {
		self.imageMargin,
		self.progressbar,
		layout = wibox.layout.fixed.horizontal
	}
end

function batteryindicator:setup(args)
	self.isBattery = true
	self.state = "none"
	self.percentage = 0
	self.refreshInterval = 3
	self.images = {
		depleting = materializeSurface(PATH.home .. "icons/battery_depleting.png"),
		charging = materializeSurface(PATH.home .. "icons/battery_charging.png"),
		charged = materializeSurface(PATH.home .. "icons/battery_charged.png")
	}
	self:makeWidget()
	self.imageMargin.widget = wibox.widget.imagebox()
	self.animation = animate.addBare(
		{
			callback = nil,
			updateLoop = function()
				self.progressbar.value = wave(self.percentage / 100, 1,10)
				return false
			end
		}
	)
	self.animation.paused = false
	self.widget = Showcase:new()
		:setup(
			{
				showcase = self.widgets,
				disableText = true,
				size = {nil, dpi(60)},
				outsideMargins = margins(0, nil, dpi(10), 0),
				halign = "left",
				showcaseMargins = margins(0),
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
