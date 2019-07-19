statusbar = {}

function statusbar:initWidgets()
  local widget = nil
  self.widgets.clock = wibox.widget.textclock("%H:%M:%S", 1)
  self.widgets.clock.font = "Hack " .. tostring(dpi(20))
  self.widgets.date = wibox.widget.textbox()

  gears.timer {
    autostart = true,
    call_now = true,
    timeout = 60,
    callback = function()
      local day = os.date("%d")
      local digit = day:sub(-1)
      local suffix = digit == "1" and "st" or digit == "2" and "nd" or digit == "3" and "rd" or "th"
      local number = day:sub(1, 1) == "0" and digit or day
      self.widgets.date.text = os.date("%a, " .. number .. suffix .. " %b %Y")
    end
  }

  local datetime = wibox.widget {
    wibox.container.place(self.widgets.clock, "center"),
    wibox.container.place(self.widgets.date, "center"),
    layout = wibox.layout.flex.vertical
  }

  local datetimeMargin = wibox.container.margin(datetime)
  datetimeMargin.margins = dpi(10)

  local datetimeBackground = wibox.container.background(datetimeMargin, self.widgets.config.bg, self.widgets.config.shape)
  local datetimeFinal = datetimeBackground
  
  local widgets = {
    datetimeFinal,
		internetindicator.widget.widget.final,
		batteryindicator.widget.widget.final,
		sysgraph.widget.widget.final,
		keyboardindicator.widget.widget.final
  }
  local widget = wibox.widget(
    gears.table.join(widgets, {layout = wibox.layout.fixed.vertical})
  )
  local margin = wibox.container.margin(widget)
  gears.table.crush(margin, self.wibox.config.margins)
  self.widget = margin
end

function statusbar:setup()
  self.screen = screens.primary
  self.wibox = {
    config = {},
    widget = nil
  }

  self.widgets = {
    config = {}
  }

	themer.apply(
		{
			{"offset", dpi(10)},
			{"size", function () return {dpi(300), self.screen.geometry.height - 2 * self.wibox.config.offset} end, true},
			{"pos", function() return {self.screen.geometry.x + (self.screen.geometry.width - (self.wibox.config.size[1] + self.wibox.config.offset)), self.screen.geometry.y + self.wibox.config.offset} end, true},
			{"shape", gears.shape.rectangle},
			{"bg", "#000000"},
			{"fg", "#FFFFFF"},
			{"margins", margins(0)}
		},
		themeful.statusBar and themeful.statusBar.wibox or {}, self.wibox.config
	)
	
	themer.apply(
		{
			{"bg", "#202020"},
			{"fg", "#FFFFFF"},
			{"shape", gears.shape.rectangle}
		},
		themeful.statusBar and themeful.statusBar.widgets or {}, self.widgets.config
	)
	
  self.widget = nil

  self.aliveTimer = gears.timer {
    single_shot = true,
    autostart = false,
    call_now = false,
    timeout = 2,
    callback = function()
      self.wibox.widget.visible = false
    end
  }

  self.animationRunning = false

  self:initWidgets()
  
  self.wibox.widget = wibox {
    ontop = true,
    visible = false,
    x = self.wibox.config.pos[1],
    y = self.wibox.config.pos[2],
    width = self.wibox.config.size[1],
    height = self.wibox.config.size[2],
    shape = self.wibox.config.shape,
    bg = self.wibox.config.bg,
    fg = self.wibox.config.fg,
    widget = self.widget
  }

  self.wibox.widget:connect_signal("mouse::enter", function()
    self.aliveTimer:stop()
  end)

  self.wibox.widget:connect_signal("mouse::leave", function()
    self.aliveTimer:again()
  end)
end

function statusbar:show()
  if not self.animationRunning and not self.wibox.widget.visible then
    self.animationRunning = true
    animate.add({
      object = self.wibox.widget,
      type = "interpolate",
      start = {self.wibox.config.pos[1] + self.wibox.config.size[1] + self.wibox.config.offset, self.wibox.config.pos[2]},
      target = self.wibox.config.pos,
      magnitude = 0.3,
      callback = function()
	self.animationRunning = false
      end
    })
  end
  self.wibox.widget.visible = true
  self.aliveTimer:again()
end

statusbar:setup()
