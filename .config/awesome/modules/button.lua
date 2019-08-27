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
			{{"bg", 1}, "#000000"},
			{{"bg", 2}, "#000000"},
			{"fg", "#FFFFFF"},
			{{"bgHover", 1}, "#AAAAAA"},
			{{"bgHover", 2}, "#AAAAAA"},
			{"fgHover", "#000000"},
			{{"bgClick", 1}, "#FFFFFF"},
			{{"bgClick", 2}, "#FFFFFF"},
			{"fgClick", "#000000"},
			{"margins", margins(0)},
			{"outsideMargins", margins(0)},
			{"icon"},
			{"shape", gears.shape.rectangle},
			{"animateHover", false},
			{"animateClick", false},
			{{"size", 1}},
			{{"size", 2}},
      {"colorFadeAmplitude", themeful.animate.colorFadeAmplitude},
      {"blinkUpAmplitude", themeful.animate.blinkUpAmplitude},
      {"blinkDownAmplitude", themeful.animate.blinkDownAmplitude}
		},
		themeful.button or {}, self.config
	)
	
	themer.apply(
		{
			{{"bg", 1}}, {{"bg", 2}}, {"fg"},	{{"bgHover", 1}}, {{"bgHover", 2}},	{"fgHover"}, {{"bgClick", 1}}, {{"bgClick", 2}},	{"fgClick"}, {"margins"}, {"icon"}, {"shape"}, {"outsideMargins"}, {{"size", 1}}, {{"size", 2}}, {"animateHover"}, {"animateClick"}, {"colorFadeAmplitude"}, {"blinkUpAmplitude"}, {"blinkDownAmplitude"}

		},
		args or {}, self.config
	)

  self.patternTemplate = {
    from = {0,0},
    to = {self.config.size[1] - extractMargin(self.config.outsideMargins), 0}
  }

	if self.config.animateHover or self.config.animateClick then
		self.colorAnimation = {}
		self.animatedColor = gears.table.map(rgbToArray, self.config.bg)
	end

  --self.config.animateHover = false
  --self.config.aniamteClick = false
  
	self:makeIcon()
	self.image = wibox.widget.imagebox()
	self.margins = wibox.container.margin(self.image)
	self.place = wibox.container.place(self.margins)
	self.background = wibox.container.background(self.place)
	self.image.image = self.icon.normal
	gears.table.crush(self.margins, self.config.margins)
	self.background.bg = gears.color.create_linear_pattern(colorsToPattern(self.config.bg, self.patternTemplate))
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
			self.colorAnimation = animate.addRgbGradient({
				element = self.background,
				colors = self.animatedColor,
				targetColors = gears.table.map(rgbToArray, self.config.bgHover),
        template = self.patternTemplate,
				amplitude = self.config.colorFadeAmplitude
			})
		else
			self.background.bg = gears.color.create_linear_pattern(colorsToPattern(self.config.bgHover, self.patternTemplate))
		end
		self.background.fg = self.config.fgHover
		self.updateCallback(true, self)
	end)

	self.final:connect_signal("mouse::leave", function()
		self.mouseIn = false
		self.image.image = self.icon.normal
		if self.config.animateHover then
			self.colorAnimation.done = true
			self.colorAnimation = animate.addRgbGradient({
				element = self.background,
				colors = self.animatedColor,
				targetColors = gears.table.map(rgbToArray, self.config.bg),
        template = self.patternTemplate,
				amplitude = self.config.colorFadeAmplitude
			})
		else
			self.background.bg = gears.color.create_linear_pattern(colorsToPattern(self.config.bg, self.patternTemplate))
		end
		self.background.fg = self.config.fg
		self.updateCallback(false, self)
	end)

	self.final:connect_signal("button::press", function()
		if self.config.animateClick then
			self.colorAnimation.done = true
			self.colorAnimation = animate.addRgbGradient({
				element = self.background,
				colors = self.animatedColor,
				targetColors = gears.table.map(rgbToArray, self.config.bgClick),
        template = self.patternTemplate,
				amplitude = self.config.blinkUpAmplitude,
				callback = function()
					if self.mouseIn then
						self.final:emit_signal("mouse::enter")
					else
						self.final:emit_signal("mouse::leave")
					end
				end
			})
		else
			self.background.bg = gears.color.create_linear_pattern(colorsToPattern(self.config.bg, self.patternTemplate))
		end
		self.callback(self)
	end)

	if args.initCallback then
		args.initCallback(self)
	end
	return self
end
