Button = {}

function Button:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function Button:makeIcon()
	if self.config.icon then
		self.icon = materializeSurface(gears.surface.load(self.config.icon), {normal = self.config.fg, highlight = self.config.fgHover})
	else
		self.icon = {normal = nil, highlight = nil}
	end
end

function Button:setIcon(icon)
	self.icon = icon
end

function Button:setup(args)

	self.updateCallback = args.updateCallback or function(isHovering, button) end
	self.callback = args.callback or function(button) end
	self.config = {}
	
	themer.apply(
		{
			{"bg", "#000000"},
			{"fg", "#FFFFFF"},
			{"bgHover", "#AAAAAA"},
			{"fgHover", "#000000"},
			{"bgClick", "#FFFFFF"},
			{"fgClick", "#000000"},
			{"margins", margins(0)},
			{"outsideMargins", margins(0)},
			{"icon"},
			{"shape", gears.shape.rectangle},
			{"animateHover", false},
			{"animateClick", false},
			{{"size", 1}},
			{{"size", 2}}
		},
		themeful.button or {}, self.config
	)
	
	themer.apply(
		{
			{"bg"}, {"fg"},	{"bgHover"},	{"fgHover"}, {"bgClick"},	{"fgClick"}, {"margins"}, {"icon"}, {"shape"}, {"outsideMargins"}, {{"size", 1}}, {{"size", 2}}, {"animateHover"}, {"animateClick"}

		},
		args or {}, self.config
	)

	if self.config.animateHover or self.config.animateClick then
		self.colorAnimation = {}
		self.animatedColor = colors.new(self.config.bg)
	end
	
	self:makeIcon()
	self.image = wibox.widget.imagebox()
	self.margins = wibox.container.margin(self.image)
	self.place = wibox.container.place(self.margins)
	self.background = wibox.container.background(self.place)
	self.image.image = self.icon.normal
	gears.table.crush(self.margins, self.config.margins)
	self.background.bg = self.config.bg
	self.background.shape = self.config.shape
	self.outsideMargins = wibox.container.margin(self.background)
	gears.table.crush(self.outsideMargins, self.config.outsideMargins)
	self.final = self.outsideMargins
	self.widget = self.final

	self.final.forced_width = self.config.size[1] or nil
	self.final.forced_height = self.config.size[2] or nil

	self.mouseIn = false
	
	self.final:connect_signal("mouse::enter", function()
		self.mouseIn = true
		self.image.image = self.icon.highlight
		if self.config.animateHover then
			self.colorAnimation.done = true
			self.colorAnimation = animate.addColor({
				element = self.background,
				color = self.animatedColor,
				targetColor = colors.new(self.config.bgHover),
				hue = "target",
				amplitude = 0.3,
			})
		else
			self.background.bg = self.config.bgHover
		end
		self.background.fg = self.config.fgHover
		self.updateCallback(true, self)
	end)

	self.final:connect_signal("mouse::leave", function()
		self.mouseIn = false
		self.image.image = self.icon.normal
		if self.config.animateHover then
			self.colorAnimation.done = true
			self.colorAnimation = animate.addColor({
				element = self.background,
				color = self.animatedColor,
				targetColor = colors.new(self.config.bg),
				hue = "target",
				amplitude = 0.3,
			})
		else
			self.background.bg = self.config.bg
		end
		self.background.fg = self.config.fg
		self.updateCallback(false, self)
	end)

	self.final:connect_signal("button::press", function()
		if self.config.animateClick then
			self.colorAnimation.done = true
			self.colorAnimation = animate.addColor({
				element = self.background,
				color = self.animatedColor,
				targetColor = colors.new(self.config.bgClick),
				amplitude = 0.3,
				callback = function()
					if self.mouseIn then
						self.final:emit_signal("mouse::enter")
					else
						self.final:emit_signal("mouse::leave")
					end
				end
			})
		else
			self.background.bg = self.config.bg
		end
		self.callback(self)
	end)

	if args.initCallback then
		args.initCallback(self)
	end
	return self
end
