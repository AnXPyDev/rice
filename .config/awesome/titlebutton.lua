titlebutton = {}

function titlebutton:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function titlebutton:setup(client, icon, callback)
	self.icon = materializeSurface(gears.surface.load(icon))
	self.image = wibox.widget.imagebox()
	self.margin = wibox.container.margin(self.image)
	self.background = wibox.container.background(self.margin)
	self.widget = self.background
	self.image.image = self.icon.onBackground
	gears.table.crush(self.margin, margins(dpi(8)))
	self.background.bg = gears.color.transparent
	self.hlColor = themeful.titlebuttonHl or colorful.complementary
	self.onHl = themeful.titlebuttonOnHL or colorful.onComplementary
	self.background:connect_signal("mouse::enter", function()
		self.image.image = self.icon.onComplementary
		self.background.bg = colorful.complementary
	end)

	self.background:connect_signal("mouse::leave", function()
		self.image.image = self.icon.onBackground
		self.background.bg = gears.color.transparent
	end)

	self.background:connect_signal("button::press", function()
		callback()
	end)
	return self
end
