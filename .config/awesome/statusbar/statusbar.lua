-- /statusbar.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

statusbar = {}

-- Initializes widgets

function statusbar:initWidgets()
	local top = wibox.widget {
    timeindicator.widget.final,
		internetindicator.widget.widget.final,
		batteryindicator.widget.widget.final,
		sysgraph.widget.widget.final,
		keyboardindicator.widget.widget.final,
		layout = wibox.layout.fixed.vertical
	}

	local bottom = wibox.widget {
		statusbuttons.widget,
		layout = wibox.layout.fixed.vertical
	}

  local widget = wibox.widget {
		wibox.container.place(top, "center", "top"),
		wibox.container.place(bottom, "center", "bottom"),
		layout = wibox.layout.stack
	}

  local margin = wibox.container.margin(widget)
  gears.table.crush(margin, self.wibox.config.margins)

  self.widget = margin
end

-- Initializes statusbar
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

	-- Keeps the statusbar visible for a certain amount of time
  self.aliveTimer = gears.timer {
    single_shot = true,
    autostart = false,
    call_now = false,
    timeout = 2,
    callback = function()
      self.wibox.widget.visible = false
			self.screen.director:remove(self.directedBox)
    end
  }

  self.directedBox = {}

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
	-- Animates the statusbar to slide in from right if it is invisible, else resets "aliveTimer"
  if not self.wibox.widget.visible then
		self.directedBox = self.screen.director:add({
			side = "right",
			padding = margins(0,dpi(10)),
			wibox = self.wibox.widget,
			priority = 0
		})
  end
  self.wibox.widget.visible = true
  self.aliveTimer:again()
end

statusbar:setup()
