playground = {}

function playground:setup()
	self.screen = screens.primary
	self.size = {
		self.screen.geometry.width - 100,
		self.screen.geometry.height - 100
	}
	self.pos = {
		self.screen.geometry.x + 50,
		self.screen.geometry.y + 50
	}
	self.widget = nil
	self.widgets = {}
	self.wibox = wibox {
		width = self.size[1],
		height = self.size[2],
		x = self.pos[1],
		y = self.pos[2],
		ontop = true,
		visible = false,
		widget = self.widget
	}
end

function playground:add(widget)
	self.widgets[#self.widgets + 1] = widget
	self:remakeWidget()
end

function playground:remakeWidget()
	self.widget = wibox.widget(
		gears.table.join({
			layout = wibox.layout.fixed.horizontal
										 }, self.widgets)
	)
	self.wibox.widget = self.widget
																								
end

function playground:toggle()
	self.wibox.visible = not self.wibox.visible
end

playground:setup()
