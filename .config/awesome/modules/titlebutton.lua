titlebutton = {}

function titlebutton:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function titlebutton:makeIcon()
	if self.config.icon then
		self.icon = materializeSurface(gears.surface.load(self.config.icon), {normal = self.config.fg, highlight = self.config.fgHl})
	else
		self.icon = {normal = nil, highlight = nil}
	end
end

function titlebutton:setIcon(icon)
	self.icon = icon
end

function titlebutton:setup(args)

	self.updateCallback = args.updateCallback or function(isHovering, button) end
	self.callback = args.callback or function(button) end
	self.config = {}
	
	themer.apply(
		{
			{"bg", gears.color.transparent},
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
			{"animateClick", false}
		},
		themeful.titleButton or {}, self.config
	)
	
	themer.apply(
		{
			{"bg"}, {"fg"},	{"bgHover"},	{"fgHover"}, {"bgClick"},	{"fgClick"}, {"margins"}, {"icon"}, {"shape"}, {"outsideMargins"}
		},
		args or {}, self.config
	)
	self:makeIcon()
	self.image = wibox.widget.imagebox()
	self.margins = wibox.container.margin(self.image)
	self.background = wibox.container.background(self.margis)
	self.image.image = self.icon.normal
	gears.table.crush(self.margins, self.config.margins)
	self.background.bg = self.config.bg
	self.background.shape = self.config.shape
	self.outsideMargins = wibox.container.margin(self.background)
	gears.table.crush(self.outsideMargins, self.config.outsideMargins)
	self.final = self.outsideMargins
	self.widget = self.final

	self.final:connect_signal("mouse::enter", function()
		self.image.image = self.icon.highlight
		self.background.bg = self.config.bgHover
		self.background.fg = self.config.fgHover
		self.updateCallback(true, self)
	end)

	self.final:connect_signal("mouse::leave", function()
		self.image.image = self.icon.normal
		self.background.bg = self.config.bg
		self.background.fg = self.config.fg
		self.updateCallback(false, self)
	end)

	self.final:connect_signal("button::press", function()
		self.callback(self)
	end)

	if args.initCallback then
		args.initCallback(self)
	end
	return self
end
