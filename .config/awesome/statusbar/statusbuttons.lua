statusbuttons = {}

function statusbuttons:setup()

	local config = {}

	config.size = {
		math.floor((themeful.statusBar.wibox.size[1] - (themeful.statusBar.wibox.margins.left + themeful.statusBar.wibox.margins.right)) / 4)
	}
	config.size[2] = config.size[1]

	themer.apply(
		{
			{"bg", themeful.button.bg},
			{"fg", themeful.button.fg},
			{"bgHover", themeful.button.bgHover},
			{"fgHover", themeful.button.fgHover},
			{"bgClick", themeful.button.bgClick},
			{"fgClick", themeful.button.fgClick},
			{"defaultBg", themeful.button.defaultBg},
			{"margins", themeful.button.margins}
		},
		themeful.statusButtons or {}, config
	)
	
	self.powerButton = Button:new():setup({
		icon = PATH.icons .. "poweroff.png",
		bg = config.bg,
		fg = config.fg,
		bgHover = config.bgHover,
		fgHover = config.fgHover,
		bgClick = config.bgClick,
		fgClick = config.fgClick,
		defaultBg = config.defaultBg,
		margins = config.margins,
		size = config.size,
		shape = function(cr, w, h)
			return gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, themeful.radius)
		end,
		callback = function()
			powermenu:showAnimate()
		end
	})
	self.menuButton = Button:new():setup({
		icon = PATH.icons .. "menu.png",
		bg = config.bg,
		fg = config.fg,
		bgHover = config.bgHover,
		fgHover = config.fgHover,
		bgClick = config.bgClick,
		fgClick = config.fgClick,
		defaultBg = config.defaultBg,
		margins = config.margins,
		size = config.size,
		shape = function(cr, w, h)
			return gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, themeful.radius)
		end,
		callback = function()
			launcher.showAnimate()
		end
	})
	self.volumeButton = Button:new():setup({
		icon = PATH.icons .. "volume.png",
		bg = config.bg,
		fg = config.fg,
		bgHover = config.bgHover,
		fgHover = config.fgHover,
		bgClick = config.bgClick,
		fgClick = config.fgClick,
		defaultBg = config.defaultBg,
		margins = config.margins,
		size = config.size,
		callback = function()
			volumecontrol:show()
		end
	})
	self.tagButton = Button:new():setup({
		icon = PATH.icons .. "tag.png",
		bg = config.bg,
		fg = config.fg,
		bgHover = config.bgHover,
		fgHover = config.fgHover,
		bgClick = config.bgClick,
		fgClick = config.fgClick,
		defaultBg = config.defaultBg,
		margins = config.margins,
		size = config.size,
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
