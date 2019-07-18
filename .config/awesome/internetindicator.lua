internetindicator = {}

function internetindicator:startRefresh()
	awful.spawn.easy_async("bash " .. PATH.config .. "grabnet.bash",
		function(stdout, stderr, exitreason, exitcode)
			self:refresh(stdout)
			self.refreshTimer:again()
		end
	)
end

function internetindicator:refresh(output)
	local lines = gears.string.split(output, "\n")
	local isLastConnected = self.isConnected
	self.wifiName = lines[1]
	self.isWifi = lines[2] == "true"
	self.signalStrength = tonumber(lines[3]) / 100
	self.isConnected = lines[4] == "true"
	if self.isConnected then
		if not isLastConnected then
			naughty.notify({text = "Back online"})
		end
		self.widget.widget.background.bg = colorful.primary
		self.widget.widget.background.fg = colorful.onPrimary
		if self.isWifi then
			self.widget:reset(self.wifiName, self.pie.final)
		else
			self.widget:reset("Ethernet", self.image)
			self.image.image = self.images.ethernet.onPrimary
		end
	else
		if isLastConnected then
			naughty.notify({text = "Gone offline"})
		end
		self.widget.widget.background.bg = themeful.statusBar.widgets.bg
		self.widget.widget.background.fg = colorful.onBackground
		self.widget:reset("Offline", self.image)
		self.image.image = self.images.ethernet.onBackground
	end
	
end

function internetindicator:refreshPie()
end

function internetindicator:pieShape(cr, perc)
	return gears.shape.transform(gears.shape.pie) : translate(- (self.pie.size[1] * 2 - (self.pie.size[1] * math.pow(2, 0.5))) / 2,0) (cr, self.pie.size[1] * 2, self.pie.size[2] * 2, - math.pi * (3 / 4), - math.pi * (1/4), self.pie.size[2] * perc)
end

function internetindicator:setup()
	self.wifiName = ""
	self.isWifi = false
	self.isConnected = false
	self.signalStrength = 0
	self.refreshInterval = 3
	self.images = {
		ethernet = materializeSurface(gears.surface.load(PATH.home .. "icons/ethernet.png")),
	}

	self.image = wibox.widget.imagebox(self.images.ethernet.onBackground)

	self.pie = {
		background = wibox.container.background(wibox.widget.textbox(), colorful.primaryShades[10], function(cr, w, h) return self:pieShape(cr, 1) end),
		foreground = wibox.container.background(wibox.widget.textbox(), colorful.onPrimary, function(cr, w, h) return self:pieShape(cr, self.signalStrength) end),
		bare = nil,
		size = {}
	}

	self.pie.bare = wibox.widget {
		self.pie.background,
		self.pie.foreground,
		layout = wibox.layout.stack
	}

	self.pie.final = wibox.container.margin(self.pie.bare)

	self.widget = Showcase:new()
		:setup(
			{
				text = "Ethernet",
				showcase = self.image,
				bg = beautiful.bg_focus,
				halign = "left",
				size = {nil, dpi(50)},
				showcaseMargins = margins(0, dpi(10), 0),
				outsideMargins = margins(0, nil, dpi(10), 0)
			}
	)
						--dasd
	self.pie.size[1] = self.widget.config.size[2] - ((self.widget.config.margins.top + self.widget.config.margins.bottom) + (self.widget.config.outsideMargins.top + self.widget.config.outsideMargins.bottom) + (self.widget.config.showcaseMargins.top + self.widget.config.showcaseMargins.bottom))
	self.pie.size[2] = self.pie.size[1]

	self.pie.final.forced_width = self.pie.size[1] * math.pow(2, 0.5)
	self.pie.final.forced_height = self.pie.size[2]
	
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

internetindicator:setup()
