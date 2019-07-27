statusbuttons = {}

function statusbuttons:setup()
	local size = {dpi(95), dpi(75)}
	local imageMargins = margins(dpi(25))
	self.powerButton = Button:new():setup({
		icon = PATH.icons .. "poweroff.png",
		outsideMargins = margins(5, 0),
		shape = themeful.shape,
		margins = imageMargins,
		size = size,
		callback = function()
			powermenu:showAnimate()
		end
	})
	self.menuButton = Button:new():setup({
		icon = PATH.icons .. "menu.png",
		outsideMargins = margins(0, 5, 0),
		margins = imageMargins,
		shape = themeful.shape,
		size = size,
		callback = function()
			launcher.showAnimate()
		end
	})
	self.volumeButton = Button:new():setup({
		icon = PATH.icons .. "volume.png",
		outsideMargins = margins(5, 5, 0),
		margins = imageMargins,
		shape = themeful.shape,
		size = size,
		callback = function()
			volumecontrol:show()
		end
	})

	self.widget = wibox.widget {
		self.menuButton.widget,
		self.volumeButton.widget,
		self.powerButton.widget,
		layout = wibox.layout.fixed.horizontal
	}
	
end

statusbuttons:setup()
