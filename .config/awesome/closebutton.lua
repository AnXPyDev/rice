closebutton = {}

local images = {
	close = materializeSurface(gears.surface.load(PATH.home .. "icons/close.png"))
}

function closebutton:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function closebutton:setup(client)
	self.image = wibox.widget.imagebox()
	self.margin = wibox.container.margin(self.image)
	self.background = wibox.container.background(self.margin)
	self.widget = self.background
	self.image.image = images.close.onBackground
	gears.table.crush(self.margin, margins(dpi(8)))
	self.background.bg = gears.color.transparent

	self.background:connect_signal("mouse::enter", function()
		self.image.image = images.close.onComplementary
		self.background.bg = colorful.complementary
	end)

	self.background:connect_signal("mouse::leave", function()
		self.image.image = images.close.onBackground
		self.background.bg = gears.color.transparent
	end)

	self.background:connect_signal("button::press", function()
		client:kill()
	end)
	return self
end
