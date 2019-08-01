-- /tagindicator.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

tagindicator = {}

-- Creates an "icon" for every tag

function tagindicator:initWidgets()
  for i = 1, #tags.list do
		if self.config.animate then
			self.animatedColors[i] = rgbToArray(self.config.clrNormal)
			self.colorAnimations[i] = {}
		end
    self.tags.widgets[i] = {}
    self.tags.widgets[i].background = wibox.container.background(
      wibox.widget.textbox(),
      self.config.clrNormal,
      self.config.tagShape
    )
    self.tags.widgets[i].margin = wibox.container.margin(self.tags.widgets[i].background)
    self.tags.widgets[i].final = self.tags.widgets[i].margin
    self.tags.widgets[i].final:connect_signal("button::press", function() tags.select(i) end)
  end
	-- Puts all created widgets into one
  self.widget.bare = wibox.widget(
    gears.table.join(
      {layout = wibox.layout.flex.horizontal},
      gears.table.map(function(widget) return widget.final end, self.tags.widgets)
    )
  )
  self.widget.margin = wibox.container.margin(self.widget.bare)
  self.widget.final = self.widget.margin
end

-- Resets theme variable of widgets

function tagindicator:refreshTheme()
	gears.table.crush(self.widget.margin, self.config.outsideMargins)
  for k, widget in pairs(self.tags.widgets) do
		gears.table.crush(widget.margin, self.config.margins)
  end
end

-- Changes colors based on which tags are occupied or focused
function tagindicator:update()
  if not #tags.list == #self.tags.widgets then
    self:setup()
  end
  for i = 1, #tags.list do
    local color = self.config.clrNormal
    if tags.list[i].selected then
      color = self.config.clrFocused
    elseif #tags.list[i]:clients() > 0 then
      color = self.config.clrOccupied
    end
		-- Apply fade between normal and current color to icons when their color is not the current one
		if self.config.animate then
			if not (self.colorAnimations[i].targetColor and (color:lower() == arrayToRgb(self.colorAnimations[i].targetColor):lower())) then
				self.colorAnimations[i].done = true
				self.colorAnimations[i] = animate.addRgbColor({
					targetColor = rgbToArray(color),
					color = self.animatedColors[i],
					element = self.tags.widgets[i].background,
					amplitude = self.config.colorFadeAmplitude,
					treshold = 0.01
				})
			end
		else
			self.tags.widgets[i].background.bg = color
		end
  end
end

-- Makes the wibox visible and restarts the aliveTimer
function tagindicator:show()
  self:update()
  self.wibox.visible = true
  self.aliveTimer:again()
end

function tagindicator:hide()
	self.wibox.visible = false
end

function tagindicator:setup()
  self.screen = screens.primary
  self.widget = nil
  self.tags = {
    widgets = {}
  }

	self.config = {}
	
	themer.apply(
		{
			{"margins", margins(0)},
			{"outsideMargins", margins(0)},
			{"tagSize", {dpi(40), dpi(40)}},
			{"size", function()	return {#tags.list * self.config.tagSize[1], self.config.tagSize[2]} end, true},
			{"pos", function() return {self.screen.geometry.x + (self.screen.geometry.width - self.config.size[1]) / 2, self.screen.geometry.y + dpi(10)} end, true},
			{"bg", "#000000"},
			{"clrNormal", "#000000"},
			{"clrFocused", "#FFFFFF"},
			{"clrOccupied", "#AAAAAA"},
			{"shape", gears.shape.rectangle},
			{"tagShape", gears.shape.rectangle},
			{"animate", false},
			{"colorFadeAmplitude", themeful.animate.colorFadeAmplitude or 0.5}
		},
		themeful.tagIndicator or {}, self.config
	)

	if self.config.animate then
		self.colorAnimations = {}
		self.animatedColors = {}
	end

	self.widget = {}
	
  self.aliveTimer = gears.timer {
    autostart = false,
    call_now = false,
    single_shot = true,
    timeout = 1,
    callback = function()
      self:hide()
    end
  }

  self:initWidgets()
  self:refreshTheme()
  self.wibox = wibox {
    x = self.config.pos[1],
    y = self.config.pos[2],
    width = self.config.size[1],
    height = self.config.size[2],
    bg = self.config.bg,
    ontop = true,
    shape = self.config.shape,
    widget = self.widget.final
  }

	-- When mouse is in the wibox, it will not disappear
  self.wibox.widget:connect_signal("mouse::enter", function() self.aliveTimer:stop() end)
  self.wibox.widget:connect_signal("mouse::leave", function() self.aliveTimer:again() end)
end

tagindicator:setup()

tagindicator.directedBox = {}

-- Makes wibox visible and shows animation (slide from top), if wibox is already visible, then just restarts aliveTimer
function tagindicator:showAnimate()
  if not tagindicator.wibox.visible then
		self.directedBox = self.screen.director:add({
			padding = themeful.outsideMargins,
			priority = 0,
			side = "top",
			wibox = self.wibox
		})
  end
  tagindicator:show()
end

function tagindicator:hide()
	self.wibox.visible = false
	self.screen.director:remove(self.directedBox)
end
