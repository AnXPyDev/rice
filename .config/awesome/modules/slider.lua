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

  self.wibox.config.pos = args.wibox.pos or {self.screen.geometry.x, self.screen.geometry.y}
  self.wibox.config.size = args.wibox.size or {dpi(400), dpi(200)}
  self.wibox.config.bg = args.wibox.bg or beautiful.slider.wibox.bg or "#000000"
  self.wibox.config.shape = args.wibox.shape or beautiful.slider.wibox.shape or gears.shape.rectangle
  
  self.sliders = {
    config = {},
    widgets = {}
  }

  self.sliders.config.sliderArgs = args.sliders.sliderArgs or beautiful.slider.sliders.sliderArgs or {
    bar_shape = gears.shape.rounded_bar,
    handle_shape = gears.shape.circle,
    bar_color = "#FFFFFF",
    handle_color = "#FFFFFF",
    bar_height = dpi(3)
  }

  self.sliders.config.direction = args.sliders.direction or beautiful.slider.sliders.direction or "vertical"
  if self.sliders.config.direction == "vertical" then
    self.sliders.config.rotation = "east"
  else
    self.sliders.config.rotation = "north"
  end
  self.sliders.config.sliderMargins = args.sliders.sliderMargins or beautiful.slider.sliders.sliderMargins or margins(20)
  self.sliders.config.sliderBg = args.sliders.sliderBg or beautiful.slider.sliders.sliderBg or "#000000"
  self.sliders.config.sliderShape = args.sliders.sliderShape or beautiful.slider.sliders.sliderShape or gears.shape.rectangle
  self.sliders.config.sliderOutsideMargins = args.sliders.sliderOutsideMargins or beautiful.slider.sliders.sliderOutsideMargins or margins(5)
  self.sliders.config.showcasePosition = args.sliders.showcasePosition or beautiful.slider.sliders.showcasePosition or "left"
  self.sliders.config.showcaseMargins = args.sliders.showcaseMargins or beautiful.slider.sliders.showcaseMargins or margins(20)
  self.sliders.config.showcaseBg = args.sliders.showcaseBg or beautiful.slider.sliders.showcaseBg or "#000000"
  self.sliders.config.showcaseShape = args.sliders.showcaseShape or beautiful.slider.sliders.showcaseShape or gears.shape.rectangle
  self.sliders.config.showcaseOutsideMargins = args.sliders.showcaseOutsideMargins or beautiful.slider.sliders.showcaseOutsideMargins or margins(5)
  self.sliders.config.sliderSize = args.sliders.sliderSize or beautiful.slider.sliders.sliderSize or {}
  self.sliders.config.showcaseSize = args.sliders.showcaseSize or beautiful.slider.sliders.showcaseSize or {}
  self.sliders.config.size = args.sliders.size or beautiful.slider.sliders.size or {}

  self.sliders.config.margins = args.sliders.margins or beautiful.slider.sliders.margins or margins(0)
  self.sliders.config.bg = args.sliders.bg or beautiful.slider.sliders.bg or "#AAAAAA"
  self.sliders.config.shape = args.sliders.shape or beautiful.slider.sliders.shape or gears.shape.rectangle
  self.sliders.config.outsideMargins = args.sliders.outsideMargins or beautiful.slider.sliders.outsideMargins or margins(2)

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
