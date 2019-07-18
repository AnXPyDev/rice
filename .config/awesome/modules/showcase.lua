Showcase = {}

function Showcase:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end


function Showcase:initWidgets()
	local widget = self.widget
	local config = self.config

	-- create text widget if text enabled
	if not config.disableText then
		widget.text = wibox.widget.textbox(config.text or "")
		widget.textPlace = wibox.container.place(widget.text)
	end
	widget.textFinal = widget.textPlace or nil

	--create showcase widget if enabled
	if not config.disableShowcase then
		widget.showcase = config.showcase or nil
		widget.showcaseMargin = wibox.container.margin(widget.showcase)
	end
	widget.showcaseFinal = widget.showcaseMargin or nil

	local widgets = {
		widget.showcaseFinal,
		widget.textFinal,
		layout = wibox.layout.fixed.horizontal
	}

	if config.showcasePosition == "bottom" or config.showcasePosition == "right" then
		widgets[1] = widget.textFinal
		widgets[2] = widget.showcaseFinal
	end

	if config.showcasePosition == "top" or config.showcasePosition == "bottom" then
		widgets.layout = wibox.layout.fixed.vertical
	end

	widget.bare = wibox.widget(widgets)
	widget.place = wibox.container.place(widget.bare)
	widget.margin = wibox.container.margin(widget.place)
	widget.background = wibox.container.background(widget.margin)
	widget.outsideMargin = wibox.container.margin(widget.background)
	widget.final = widget.outsideMargin

end

function Showcase:refreshTheme()
	local widget = self.widget
	local config = self.config

	if not config.disableText then
		widget.text.font = config.font
		widget.textPlace.halign = config.textHalign
		widget.textPlace.valign = config.textValign
	end
	gears.table.crush(widget.showcaseMargin, config.showcaseMargins)
	widget.place.halign = config.halign
	widget.place.valign = config.valign
	gears.table.crush(widget.margin, config.margins)
	widget.background.bg = config.bg
	widget.background.fg = config.fg
	widget.background.shape = config.shape
	gears.table.crush(widget.outsideMargin, config.outsideMargins)
	widget.final.forced_width = config.size[1] or nil
	widget.final.forced_height = config.size[2] or nil
end

function Showcase:reset(text, showcase)
	local text = text or nil
	local showcase = showcase or nil
	if text then
		self.widget.text.text = text
	end
	if showcase then
		self.widget.showcaseMargin.widget = showcase
	end
end

function Showcase:setup(args)
	-- initialize config table
  self.config = {}
	-- initialize widget table which holds all containers leading up and including the final widget
  self.widget = {}

	themer.apply(
		{
			{"text", nil},
			{"showcase", nil},
			{"disableText", false},
			{"disableShowcase", false},
			{"showcasePosition", "left"},
			{"showcaseMargins", margins(0)},
			{"textHalign", "center"},
			{"textValign", "center"},
			{"halign", "center"},
			{"valign", "center"},
			{"margins", margins(0)},
			{"outsideMargins", margins(0)},
			{"bg", "#000000"},
			{"fg", "#FFFFFF"},
			{"shape", gears.shape.rectangle},
			{"size", {}},
			{"font", beautiful.font}
		},
		beautiful.showcase or {},
		self.config
	)

	themer.apply(
		{
			{"text"},
			{"showcase"},
			{"disableText"},
			{"disableShowcase"},
			{"showcasePosition"},
			{"showcaseMargins"},
			{"textHalign"},
			{"textValign"},
			{"halign"},
			{"valign"},
			{"margins"},
			{"outsideMargins"},
			{"bg"},
			{"fg"},
			{"shape"},
			{"size"},
			{"font"}
		},
		args or {},
		self.config
	)

	self:initWidgets()
	self:refreshTheme()

	return self
end
