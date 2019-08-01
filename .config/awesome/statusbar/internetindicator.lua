-- /intenetindicator.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

internetindicator = {}

-- Starts refreshing internet info using a script that returns wifi name, wifi quality, whether you are actually connected, and if you are connected via wifi

function internetindicator:startRefresh()
	awful.spawn.easy_async("bash " .. PATH.config .. "grabnet.bash",
		function(stdout, stderr, exitreason, exitcode)
			self:refresh(stdout)
			-- Starts timer so a refresh happens again
			self.refreshTimer:again()
		end
	)
end

-- Changes the look of the widget based on gathered info

function internetindicator:refresh(output)
	-- Splits output into lines
	local lines = gears.string.split(output, "\n")
	local isLastConnected = self.isConnected
	self.wifiName = lines[1]
	self.isWifi = lines[2] == "true"
	self.signalStrength = tonumber(lines[3]) / 100
	self.isConnected = lines[4] == "true"
	if self.isConnected then

		if not isLastConnected then

			-- Notifies about connection when state changes

			naughty.notify({text = "Back online"})

			if self.config.animate then
				-- Start animation to fade background color into highlight color
				self.backgroundAnimation.done = true
				self.backgroundAnimation = animate.addRgbColor({
					element = self.widget.widget.background,
					color = self.backgroundColor,
					targetColor = rgbToArray(self.config.bgOnline),
					amplitude = self.config.colorFadeAmplitude,
					treshold = 0.01
				})
			end
		end

		if not self.config.animate then
			self.widget.widget.background.bg = self.config.bgOnline
		end

		self.widget.widget.background.fg = self.config.fgOnline

		-- Sets text and showcase of widget
		if self.isWifi then
			self.widget:reset(self.wifiName, self.pie.final)
		else
			self.widget:reset("Ethernet", self.image)
			self.image.image = self.images.ethernet.onPrimary
		end

	else
		if isLastConnected then

			-- Notifies about connection when state changes
			naughty.notify({text = "Gone offline"})

			if self.config.animate then
				-- Start animation to fade highlight color into background color
				self.backgroundAnimation.done = true
				self.backgroundAnimation = animate.addRgbColor({
					element = self.widget.widget.background,
					color = self.backgroundColor,
					targetColor = rgbToArray(self.config.bg),
					amplitude = self.config.colorFadeAmplitude,
					treshold = 0.01
				})
			end
		end

		if not self.config.animate then
			self.widget.widget.background.bg = self.config.bg
		end

		self.widget.widget.background.fg = self.config.fg
		self.widget:reset("Offline", self.image)
		
		-- Ethernet icon is shown even when offline
		self.image.image = self.images.ethernet.onBackground
	end
	
end

-- A shape that looks like the classic wifi indicator from phones, a pie like shape that can scale based on wifi qulity

function internetindicator:pieShape(cr, perc)
	return gears.shape.transform(gears.shape.pie) : translate(- (self.pie.size[1] * 2 - (self.pie.size[1] * math.pow(2, 0.5))) / 2,0) (cr, self.pie.size[1] * 2, self.pie.size[2] * 2, - math.pi * (3 / 4), - math.pi * (1/4), self.pie.size[2] * perc)
end

-- Initializes "internetindicator"

function internetindicator:setup()
	self.wifiName = ""
	self.isWifi = false
	self.isConnected = false
	self.signalStrength = 0
	self.refreshInterval = 3
	self.images = {
		ethernet = materializeSurface(gears.surface.load(PATH.icons .. "ethernet.png")),
	}

	self.config = {}

	themer.apply(
		{
			{"bg", "#000000"},
			{"bgOnline", "#FFFFFF"},
			{"fg", "#FFFFFF"},
			{"fgOnline", "#000000"},
			{"bg2Online", "#aaaaaa"},
			{"shape", gears.shape.rectangle},
			{"animate", false},
			{"colorFadeAmplitude", themeful.animate.colorFadeAmplitude or 0.5}
		},
		themeful.internetIndicator or {}, self.config
	)
	
	self.image = wibox.widget.imagebox(self.images.ethernet.onBackground)

	-- Creates two wifi icons, which are stacked over each other, one acting as a background and other indicates quality
	
	self.pie = {
		background = wibox.container.background(wibox.widget.textbox(), self.config.bg2Online, function(cr, w, h) return self:pieShape(cr, 1) end),
		foreground = wibox.container.background(wibox.widget.textbox(), self.config.fgOnline, function(cr, w, h) return self:pieShape(cr, self.signalStrength) end),
		bare = nil,
		size = {}
	}

	-- Wifi icon as a full widget
	
	self.pie.bare = wibox.widget {
		self.pie.background,
		self.pie.foreground,
		layout = wibox.layout.stack
	}

	self.pie.final = wibox.container.margin(self.pie.bare)

	if self.config.animate then
		-- Animation that fades background color
		self.backgroundAnimation = {}
		-- Background Color used for animating
		self.backgroundColor = rgbToArray(self.config.bg)
	end

	self.widget = Showcase:new()
		:setup(
			{
				text = "Offline",
				showcase = self.image,
				bg = beautiful.bg_focus,
				halign = "left",
				size = {nil, dpi(40)},
				showcaseMargins = margins(0, dpi(10), 0),
				outsideMargins = margins(0),
				shape = self.config.shape
			}
	)

	-- Calculates size of wifi icon
	self.pie.size[1] = self.widget.config.size[2] - ((self.widget.config.margins.top + self.widget.config.margins.bottom) + (self.widget.config.outsideMargins.top + self.widget.config.outsideMargins.bottom) + (self.widget.config.showcaseMargins.top + self.widget.config.showcaseMargins.bottom))
	self.pie.size[2] = self.pie.size[1]

	-- Applies the size
	self.pie.final.forced_width = self.pie.size[1] * math.pow(2, 0.5)
	self.pie.final.forced_height = self.pie.size[2]

	-- Refreshes info
	
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

-- Initializes "internetindicator"

internetindicator:setup()
