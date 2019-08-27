Slider = {}

function Slider:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function Slider:initWidgets()
  for i = 1, #self.sliders.config.list do
    local widget = {}
    widget.slider = wibox.widget(
      gears.table.join(self.sliders.config.list[i].sliderArgs or self.sliders.config.sliderArgs, {widget = wibox.widget.slider})
    )
    widget.sliderRotate = wibox.container.rotate(widget.slider)
    widget.sliderMargin = wibox.container.margin(widget.sliderRotate)
    widget.sliderBackground = wibox.container.background(widget.sliderMargin)
    widget.sliderOutsideMargin = wibox.container.margin(widget.sliderBackground)
    widget.sliderFinal = widget.sliderOutsideMargin

    local widgets
    
    if self.sliders.config.list[i].showcase then
      widget.showcase = self.sliders.config.list[i].showcase
      widget.showcaseMargin = wibox.container.margin(widget.showcase)
      widget.showcaseBackground = wibox.container.background(widget.showcaseMargin)
      widget.showcaseOutsideMargin = wibox.container.margin(widget.showcaseBackground)
      widget.showcaseFinal = widget.showcaseOutsideMargin
      
      widgets = {
	widget.sliderFinal,
	widget.showcaseFinal
      }
      
      if self.sliders.config.showcasePosition == "top" or self.sliders.config.showcasePosition == "left" then
	widgets[1] = widget.showcaseFinal
	widgets[2] = widget.sliderFinal
      end
      
    else
      widgets = {
	widget.sliderFinal
      }
    end
    
    if self.sliders.config.direction == "horizontal" then
      widgets.layout = wibox.layout.fixed.horizontal
    else
      widgets.layout = wibox.layout.fixed.vertical
    end

    widget.bare = wibox.widget(widgets)
    widget.margin = wibox.container.margin(widget.bare)
    widget.background = wibox.container.background(widget.margin)
    widget.outsideMargin = wibox.container.margin(widget.background)
    widget.final = widget.outsideMargin
    self.sliders.widgets[i] = widget
  end
  
  local widgets = {
    layout = wibox.layout.flex.horizontal
  }

  if self.sliders.config.direction == "horizontal" then
    widgets.layout = wibox.layout.flex.vertical
  end

  widgets = gears.table.join(widgets, gears.table.map(function(widget) return widget.final end, self.sliders.widgets))
  
  self.widget = wibox.widget(widgets)
end

function Slider:refreshTheme()
  for key, widget in pairs(self.sliders.widgets) do
    widget.sliderRotate.direction = self.sliders.config.rotation
    gears.table.crush(widget.sliderMargin, self.sliders.config.sliderMargins)
    widget.sliderBackground.bg = self.sliders.config.sliderBg
    widget.sliderBackground.shape = self.sliders.config.sliderShape
    gears.table.crush(widget.sliderOutsideMargin, self.sliders.config.sliderOutsideMargins)
    widget.sliderOutsideMargin.forced_width = self.sliders.config.sliderSize[1] or nil
    widget.sliderOutsideMargin.forced_height = self.sliders.config.sliderSize[2] or nil
    if widget.showcase then
      gears.table.crush(widget.showcaseMargin, self.sliders.config.showcaseMargins)
      widget.showcaseBackground.bg = self.sliders.config.showcaseBg
      widget.showcaseBackground.shape = self.sliders.config.showcaseShape
      gears.table.crush(widget.showcaseOutsideMargin, self.sliders.config.showcaseOutsideMargins)
      widget.showcaseOutsideMargin.forced_width = self.sliders.config.showcaseSize[1] or nil
      widget.showcaseOutsideMargin.forced_height = self.sliders.config.showcaseSize[2] or nil
    end
    gears.table.crush(widget.margin, self.sliders.config.margins)
    widget.background.bg = self.sliders.config.bg
    widget.background.shape = self.sliders.config.shape
    gears.table.crush(widget.outsideMargin, self.sliders.config.outsideMargins)
    widget.outsideMargin.forced_width = self.sliders.config.size[1] or nil
    widget.outsideMargin.forced_height = self.sliders.config.size[2] or nil

  end
end

function Slider:setup(args)
  self.screen = args.screen
  self.wibox = {
    config = {},
    widget = nil
  }

	themer.apply(
		{
			{"pos", {self.screen.geometry.x, self.screen.geometry.y}},
			{"size", {dpi(400), dpi(200)}},
			{"bg", "#000000"},
			{"shape", gears.shape.rectangle}
		},
		themeful.slider and themeful.slider.wibox or nil, self.wibox.config
	)

	themer.apply(
		{
			{"pos"}, {"size"}, {"bg"}, {"shape"}
		},
		args.wibox or {}, self.wibox.config
	)
	
  self.sliders = {
    config = {},
    widgets = {}
  }

	themer.apply(
		{
			{"sliderArgs", {
				bar_shape = gears.shape.rounded_bar,
				handle_shape = gears.shape.circle,
				bar_color = "#FFFFFF",
				handle_color = "#FFFFFF",
				bar_height = dpi(3)
			}},
			{"direction", "horizontal"},
			{"sliderMargins", margins(0)},
			{"sliderBg", "#000000"},
			{"sliderShape", gears.shape.rectangle},
			{"sliderOutsideMargins", margins(0)},
			{"showcasePosition", "left"},
			{"showcaseMargins", margins(0)},
			{"showcaseBg", "#000000"},
			{"showcaseShape", gears.shape.rectangle},
			{"showcaseOutsideMargins", margins(0)},
			{"sliderSize", {}},
			{"showcaseSize", {}},
			{"size", {}},
			{"margins", margins(0)},
			{"bg", "#000000"},
			{"shape", gears.shape.rectangle},
			{"outsideMargins", margins(0)}
		},
		themeful.slider and themeful.slider.sliders or {}, self.sliders.config
	)

	themer.apply(
		{
			{"sliderArgs"},	{"direction"},	{"sliderMargins"},	{"sliderBg"},	{"sliderShape"},	{"sliderOutsideMargins"},	{"showcasePosition"},	{"showcaseMargins"},	{"showcaseBg"},	{"showcaseShape"},	{"showcaseOutsideMargins"},	{"sliderSize"},	{"size"},	{"bg"},	{"shape"},	{"outsideMargins"}
		},
		args.sliders or {}, self.sliders.config
	)

	if self.sliders.config.direction == "horizontal" then
		self.sliders.config.rotation = "north"
	else
		self.sliders.config.rotation = "east"
	end
	
  self.sliders.config.list = args.sliders.list
  
  self.widget = nil
  self:initWidgets()
  self:refreshTheme()
  
  self.wibox.widget = wibox {
    ontop = true,
    visible = false,
    bg = self.wibox.config.bg,
    x = self.wibox.config.pos[1],
    y = self.wibox.config.pos[2],
    width = self.wibox.config.size[1],
    height = self.wibox.config.size[2],
    widget = self.widget,
    shape = self.wibox.config.shape
  }
  return self
end

function Slider:toggle()
  self.wibox.widget.visible = not self.wibox.widget.visible
end
