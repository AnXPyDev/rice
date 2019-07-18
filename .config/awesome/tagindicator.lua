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

	themer.apply(
		{
			{"size", {dpi(40), dpi(40)}},
			{"shape", gears.shape.rectangle},
			{"margins", margins(0)},
			{"colors.occupied", "#757575"},
			{"colors.focused", "#FFFFFF"},
			{"colors.normal", "#000000"}
		},
		themeful.tagIndicator and themeful.tagIndicator.tags, self.tags.config
	)

	themer.apply(
		{
			{"margins", margins(0)},
			{{"size", 1}, #tags.list * self.tags.config.size[1]},
			{{"size", 2}, self.tags.config.size[2]},
			{{"pos", 1}, function() return self.screen.geometry.x + (self.screen.geometry.width - self.wibox.config.size[1]) / 2 end, true},
			{{"pos", 2}, self.screen.geometry.y + dpi(10)},
			{"bg", "#000000"},
			{"ontop", true},
			{"shape", gears.shape.rectangle}
		},
		themeful.tagIndicator and themeful.tagIndicator.wibox, self.wibox.config
	)
	
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

tagindicator.animationRunning = false

function tagindicator.showAnimate()
  if not tagindicator.animationRunning and not tagindicator.wibox.widget.visible then
    tagindicator.animationRunning = true
    animate.add({
      object = tagindicator.wibox.widget,
      start = {
				tagindicator.wibox.config.pos[1],
				tagindicator.wibox.config.pos[2] - tagindicator.wibox.config.size[2]
      },
      target = {
				tagindicator.wibox.config.pos[1],
				tagindicator.wibox.config.pos[2]
      },
      type = "interpolate",
      magnitude = 0.3,
      amount = 5,
      callback = function()
				tagindicator.animationRunning = false
      end
    })
  end
  tagindicator:show()
end
