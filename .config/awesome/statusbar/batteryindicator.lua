-- /batteryindicator.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

-- This is a battery indicator for my statusbar
-- It uses "Showcase" to display an icon representing the battery state (charging, depleting, charged ..)
-- It alse shows a progressbar representing the percentage of the battery

batteryindicator = {}

-- Starts async spawn of a script that returns battery info (state and percentage)
-- Then passes the output to "refresh"

function batteryindicator:startRefresh()
	awful.spawn.easy_async("bash " .. PATH.config .. "grabbattery.bash",
		function(stdout, stderr, exitreason, exitcode)
			self:refresh(stdout)
			-- Starts refreshing again
			self.refreshTimer:again()
		end
	)
end

-- Changes the appearance of widget based on gathered info

function batteryindicator:refresh(output)
	output = gears.string.split(output, "\n")
	local lastState = self.state
	-- If the computer is running off wall power, widget behaves as fully charged
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

-- Initializes all stages of the subwidgets

function batteryindicator:makeWidget()
	self.progressbar = wibox.widget.progressbar()
	self.progressbar.shape = self.config.barShape
	self.progressbar.bar_shape = self.config.barShape
	self.progressbar.color = self.config.bgHl
	self.progressbar.background_color = self.config.bg2Hl
	self.imageMargin = wibox.container.margin()
	gears.table.crush(self.imageMargin, margins(0, dpi(10), 0))
	self.widgets = wibox.widget {
		self.imageMargin,
		self.progressbar,
		layout = wibox.layout.fixed.horizontal
	}
end

-- Initializes widget

function batteryindicator:setup(args)
	self.isBattery = true
	self.state = "none"
	self.percentage = 0
	self.refreshInterval = 3
	self.images = {
		depleting = materializeSurface(PATH.icons .. "battery_depleting.png"),
		charging = materializeSurface(PATH.icons .. "battery_charging.png"),
		charged = materializeSurface(PATH.icons .. "battery_charged.png")
	}

	self.config = {}

	themer.apply(
		{
			{"bg", "#000000"},
			{"fg", "#FFFFFF"},
			{"bgHl", "#FFFFFF"},
			{"bg2Hl", "#aaaaaa"},
			{"barShape", gears.shape.rectangle},
			{"shape", gears.shape.rectangle}
		},
		themeful.batteryIndicator or {}, self.config
	)
	
	self:makeWidget()

	-- sets the default icon as a placeholder until first refresh happens

	self.imageMargin.widget = wibox.widget.imagebox(self.images.charging.onBackground)

	-- This animation is active when battery is charging, and waves the progressbar between 100% and current percentage, for visual effect
	
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
				shape = self.config.shape,
				bg = self.config.bg
			}
					)
						
	-- Refreshes battery info

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

-- Initializes "batteryindicator"

batteryindicator:setup(args)
