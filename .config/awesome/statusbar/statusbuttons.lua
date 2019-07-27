statusbuttons = {}

function statusbuttons:setup()
	local size = {math.floor((dpi(300) - 2 * dpi(10)) / 4),math.floor((dpi(300) - 2 * dpi(10)) / 4)}
	local imageMargins = margins(dpi(25))
	self.powerButton = Button:new():setup({
		icon = PATH.icons .. "poweroff.png",
		margins = imageMargins,
		size = size,
		shape = function(cr, w, h)
			return gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, themeful.radius)
		end,
		callback = function()
			powermenu:showAnimate()
		end
	})
	self.menuButton = Button:new():setup({
		icon = PATH.icons .. "menu.png",
		margins = imageMargins,
		size = size,
		shape = function(cr, w, h)
			return gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, themeful.radius)
		end,
		callback = function()
			launcher.showAnimate()
		end
	})
	self.volumeButton = Button:new():setup({
		icon = PATH.icons .. "volume.png",
		margins = imageMargins,
		size = size,
		callback = function()
			volumecontrol:show()
		end
	})
	self.tagButton = Button:new():setup({
		icon = PATH.icons .. "tag.png",
		margins = imageMargins,
		size = size,
		callback = function()
			tagindicator:showAnimate()
		end
	})

	self.widget = wibox.widget {
		self.menuButton.widget,
		self.tagButton.widget,
		self.volumeButton.widget,
		self.powerButton.widget,
		layout = wibox.layout.fixed.horizontal
	}
	
end

statusbuttons:setup()
