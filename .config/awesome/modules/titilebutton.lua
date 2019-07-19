titlebutton = {}

function titlebutton:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function titlebutton:makeIcon()
	self.icon = materializeSurface(gears.surface.load(self.config.icon), {normal = self.config.fg, highlight = self.config.fgHl})
end

function titlebutton:setup(args)

	self.updateCallback = args.updateCallback or function(isHovering, button) end
	self.callback = args.callback or function(button) end
	self.config = {}
	
	themer.apply(
		{
			{"bg", gears.color.transparent},
			{"fg", "#FFFFFF"},
			{"bgHl", "#FFFFFF"},
			{"fgHl", "#000000"},
			{"margins", margins(0)},
			{"icon"}
		},
		themeful.titleButton or {}, self.config
	)
	
	themer.apply(
		{
			{"bg"}, {"fg"},	{"bgHl"},	{"fgHl"}, {"margins"}, {"icon"}
		},
		args or {}, self.config
	)
	self:makeIcon()
	self.image = wibox.widget.imagebox()
	self.margin = wibox.container.margin(self.image)
	self.background = wibox.container.background(self.margin)
	self.widget = self.background
	self.image.image = self.icon.normal
	gears.table.crush(self.margin, self.config.margins)
	self.background.bg = self.config.bg

	self.background:connect_signal("mouse::enter", function()
		self.image.image = self.icon.highlight
		self.background.bg = self.config.bgHl
		self.updateCallback(true, self)
	end)

	self.background:connect_signal("mouse::leave", function()
		self.image.image = self.icon.normal
		self.background.bg = self.config.bg
		self.updateCallback(false, self)
	end)

	self.background:connect_signal("button::press", function()
		self.callback(self)
	end)
	return self
end
