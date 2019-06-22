tagIndicator = {}

function tagIndicator.shape(cr, w, h)
  return gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
end

function tagIndicator:initWidgets()
  self.surfaces.focused = gears.surface.load_from_shape(self.widgetSize[1], self.widgetSize[2], gears.shape.rectangle, beautiful.tagIndicator_focused or beautiful.fg_focused)
  self.surfaces.occupied = gears.surface.load_from_shape(self.widgetSize[2], self.widgetSize[2], gears.shape.rectangle, beautiful.tagIndicator_occupied or beautiful.bg_focused)
  self.surfaces.normal = gears.surface.load_from_shape(self.widgetSize[1], self.widgetSize[2], gears.shape.rectangle, beautiful.tagIndicator_normal or beautiful.bg_normal)
  
  local function widgetShape(cr, w, h)
    return gears.shape.transform(gears.shape.circle) : translate((self.widgetSize[1] * (1 - self.widgetMult)) / 2, (self.widgetSize[2] * (1 - self.widgetMult)) / 2) (cr, self.widgetSize[1] * self.widgetMult, self.widgetSize[2] * self.widgetMult)
  end
  
  for i = 1, #tags.list do
    local widget = wibox.widget.imagebox(
      self.surfaces.focused,
      false,
      widgetShape
    )
    
    self.widgets = gears.table.join(self.widgets, {widget})
  end

  self.widget = wibox.widget(gears.table.join({layout = wibox.layout.flex.horizontal}, self.widgets))
  
end

function tagIndicator:update()
  if not self.widgets or not #tags.list == #self.widgets then
    self:setup()
  end
  for i = 1, #tags.list do
    local surface = nil
    if tags.list[i].selected then
      surface = self.surfaces.focused
    elseif #tags.list[i]:clients() > 0 then
      surface = self.surfaces.occupied
    else
      surface = self.surfaces.normal
    end
    self.widgets[i].image = surface
    self.widgets[i]:emit_signal("widget::redraw_needed")
  end
end

function tagIndicator:setup()
  self.screen = screens.primary
  self.widgetSize = {dpi(40), dpi(40)}
  self.widgetMult = 0.5
  self.size = {self.widgetSize[1] * #tags.list, self.widgetSize[2]}
  self.offset = 30
  self.pos = {self.screen.geometry.x + (self.screen.geometry.width - self.size[1]) / 2, self.screen.geometry.y + dpi(self.offset)}
  self.surfaces = {}
  self.widgets = {}
  self.widget = nil
  self.aliveTimer = gears.timer {
    timeout = 1,
    autostart = false,
    call_now = false,
    callback = function()
      self.wibox.visible = false
    end
  }
  self:initWidgets()
  self.wibox = wibox({
    ontop = true,
    x = self.pos[1],
    y = self.pos[2],
    width = self.size[1],
    height = self.size[2],
    bg = beautiful.tagIndicator_bg or beautiful.bg_normal,
    fg = beautiful.tagIndicator_fg or beautiful.fg_normal,
    shape = self.shape,
    widget = self.widget
  })
end

function tagIndicator:show()
  self:update()
  self.wibox.visible = true
  self.aliveTimer:again()
end

tagIndicator:update()
