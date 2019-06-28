tagindicator = {}

function tagindicator:initWidgets()
  for i = 1, #tags.list do
    self.tags.widgets[i] = {}
    self.tags.widgets[i].background = wibox.container.background(
      wibox.widget.textbox(),
      self.tags.config.colors.normal,
      self.tags.config.shape
    )
    self.tags.widgets[i].margin = wibox.container.margin(self.tags.widgets[i].background)
    self.tags.widgets[i].final = self.tags.widgets[i].margin
    self.tags.widgets[i].final:connect_signal("button::press", function() tags.list[i]:view_only() self:update() end)
  end
  self.tags.contained = wibox.widget(
    gears.table.join(
      {layout = wibox.layout.flex.horizontal},
      gears.table.map(function(widget) return widget.final end, self.tags.widgets)
    )
  )
  self.tags.margin = wibox.container.margin(self.tags.contained)
  self.widget = self.tags.margin
end

function tagindicator:refreshTheme()
  self.tags.margin.left = self.wibox.config.margins.left
  self.tags.margin.right = self.wibox.config.margins.right
  self.tags.margin.top = self.wibox.config.margins.top
  self.tags.margin.bottom = self.wibox.config.margins.bottom
  for k, widget in pairs(self.tags.widgets) do
    widget.margin.left = self.tags.config.margins.left
    widget.margin.right = self.tags.config.margins.right
    widget.margin.top = self.tags.config.margins.top
    widget.margin.bottom = self.tags.config.margins.bottom
  end
end

function tagindicator:update()
  if not #tags.list == #self.tags.widgets then
    self:setup()
  end
  for i = 1, #tags.list do
    local color = self.tags.config.colors.normal
    if tags.list[i].selected then
      color = self.tags.config.colors.focused
    elseif #tags.list[i]:clients() > 0 then
      color = self.tags.config.colors.occupied
    end
    self.tags.widgets[i].background.bg = color
  end
end

function tagindicator:show()
  self:update()
  self.wibox.widget.visible = true
  self.aliveTimer:again()
end

function tagindicator:setup()
  self.screen = screens.primary
  self.widget = nil
  self.wibox = {
    config = {},
    widget = nil
  }
  self.tags = {
    config = {},
    widgets = {}
  }
  self.tags.config.size = beautiful.tagIndicator.tags.size
  self.tags.config.shape = beautiful.tagIndicator.tags.shape or gears.shape.rectangle
  self.tags.config.margins = beautiful.tagIndicator.tags.margins or {left = 0, right = 0, top = 0, bottom = 0}
  self.tags.config.colors = beautiful.tagIndicator.tags.colors or {occupied = "#757575", focused = "#FFFFFF", normal = "#000000"}

  self.wibox.config.margins = beautiful.tagIndicator.wibox.margins or {left = 0, right = 0, top = 0, bottom = 0}
  self.wibox.config.size = {}
  self.wibox.config.size[1] = beautiful.tagIndicator.wibox.size[1] or #tags.list * self.tags.config.size[1]
  self.wibox.config.size[2] = beautiful.tagIndicator.wibox.size[2] or self.tags.config.size[2]
  self.wibox.config.pos = {}
  self.wibox.config.pos[1] = beautiful.tagIndicator.wibox.pos[1] or self.screen.geometry.x + (self.screen.geometry.width - self.wibox.config.size[1]) / 2
  self.wibox.config.pos[2] = beautiful.tagIndicator.wibox.pos[2] or self.screen.geometry.y
  self.wibox.config.bg = beautiful.tagIndicator.wibox.bg or "#000000"
  self.wibox.config.ontop = true
  self.wibox.config.shape = beautiful.tagIndicator.wibox.shape or gears.shape.rectangle

  self.aliveTimer = gears.timer {
    autostart = false,
    call_now = false,
    single_shot = true,
    timeout = 1,
    callback = function()
      self.wibox.widget.visible = false
    end
  }
  self:initWidgets()
  self:refreshTheme()
  self.wibox.widget = wibox {
    x = self.wibox.config.pos[1],
    y = self.wibox.config.pos[2],
    width = self.wibox.config.size[1],
    height = self.wibox.config.size[2],
    bg = self.wibox.config.bg,
    ontop = self.wibox.config.ontop,
    shape = self.wibox.config.shape,
    widget = self.widget
  }
  self.wibox.widget:connect_signal("mouse::enter", function() self.aliveTimer:stop() end)
  self.wibox.widget:connect_signal("mouse::leave", function() self.aliveTimer:again() end)
end

tagindicator:setup()
