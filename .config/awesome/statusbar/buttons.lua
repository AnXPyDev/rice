statusButtons = {}

function statusButtons:setup()
	self.powerButton = Button:new({
		icon = PATH.icons .. "menu.png",
		margins 
	})
	self.menuButton = Button:new({
		
	})
	self.volumeButton = Button:new({
		
	})

	self.widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal
	}
	
end
