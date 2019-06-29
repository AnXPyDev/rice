Slider = {}

function Slider:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function Slider:initWidgets()
  for i = 1, #self.sliders.list do
    self.sliders.widgets[i] = {}
    local widget = self.sliders.widgets[i]
    widget.slider = wibox.widget.slider()
    widget.showcaseMargin = wibox.container.margin()
    widget.sliderMargin = wibox.container.margin(widget.slider)
    widget.background = wibox.container.background()
  end
end

function Slider:refreshTheme()
end

function Slider:setup(args)
  self.screen = args.screen
  self.wibox = {
    config = {},
    widget = nil
  }

  self.wibox.config.pos = args.wibox.pos or {self.screen.geometry.x, self.screen.geometry.y}
  self.wibox.config.size = args.wibox.size or {dpi(100), dpi(400)}
  self.wibox.config.bg = args.wibox.bg or beautiful.slider.wibox.bg or "#000000"
  self.wibox.config.fg = args.wibox.fg or beautiful.slider.wibox.fg or "#FFFFFF"
  self.wibox.config.margins = args.wibox.margins or beautiful.slider.wibox.margins or {left = 0, right = 0, top = 0, bottom = 0}
  self.wibox.config.shape = args.wibox.shape or beautiful.slider.wibox.shape or gears.shape.rectangle
  
  self.sliders = {
    config = {},
    widgets = {}
  }

  self.sliders.config.bg = args.sliders.bg or beautiful.slider.sliders.bg or "#000000"
  self.sliders.config.fg = args.sliders.bg or beautiful.slider.sliders.bg or "#FFFFFF"
  self.sliders.config.handleSize = args.sliders.handleSize or beautiful.slider.sliders.handleSize or {dpi(30), dpi(30)}
  self.sliders.config.handleMargins = args.sliders.handleMargins or beautiful.slider.sliders.handleMargins or {left = 0, right = 0, top = 0, bottom = 0}
  self.sliders.config.handleShape = args.sliders.handleShape or beautiful.slider.sliders.handleShape or gears.shape.rectangle
  self.sliders.config.handleBg = args.sliders.handleBg or beautiful.slider.sliders.handleBg or "#FFFFFF"
  self.sliders.config.handleBorder = args.sliders.handleBorder or beautiful.slider.sliders.handleBorder or "#FFFFFF"
  self.sliders.config.handleBorderWidth = args.sliders.handleBorderWidth or beautiful.slider.sliders.handleBorderWidth or 0
  self.sliders.config.barWidth = args.sliders.barWidth or beautiful.slider.sliders.barWidth or dpi(10)
  self.sliders.config.barMargins = args.sliders.barMargins or beautiful.slider.sliders.barMargins or {left = 0, right = 0, top = 0, bottom = 0}
  self.sliders.config.barShape = args.sliders.barShape or beautiful.slider.sliders.barShape or gears.shape.rectangle
  self.sliders.config.barBg = args.sliders.barBg or beautiful.slider.sliders.barBg or "#AAAAAA"
  self.sliders.config.barBorderWidth = args.sliders.barBorderWidth or beautiful.slider.sliders.barBorderWidth or 0
  self.sliders.config.barBorder = args.sliders.barBorder or beautiful.slider.sliders.barBorder or "#FFFFFF"
  self.sliders.config.shape = args.sliders.shape or beautiful.slider.sliders.shape or gears.shape.rectangle
  self.sliders.config.margins = args.sliders.margins or beautiful.slider.sliders.margins or {left = 0, right = 0, top = 0, bottom = 0}
  self.sliders.config.outsideMargins = args.sliders.outsideMargins or beautiful.slider.sliders.outsideMargins or {left = 0, right = 0, top = 0, bottom = 0}
  self.sliders.config.showcasePos = 

  self.sliders.list = args.sliders.list
  
  self.widget = nil
  
  self:initWidgets()
  
  self.wibox.widget = wibox {
    x = self.wibox.config.pos[1],
    y = self.wibox.config.pos[2],
    width = self.wibox.config.size[1],
    height = self.wibox.config.size[2],
    bg = self.wibox.config.bg,
    fg = self.wibox.config.fg,
    visible = false,
    ontop = true,
    widget = self.widget
  }
  
end
