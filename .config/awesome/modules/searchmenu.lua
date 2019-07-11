SearchMenu = {}

function SearchMenu:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function SearchMenu.shape(cr, w, h)
  return gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
end

function SearchMenu:runPrompt()
  awful.prompt.run({
    textbox = self.prompt.widget.bare,
    prompt = self.prompt.config.text,
    font = self.prompt.config.font,
    bg_cursor = self.prompt.config.fg,
    fg_cursor = self.prompt.config.bg,
    changed_callback = function()
      self.prompt.widget.bare.font = self.prompt.config.font
      self:update(self.prompt.widget.bare.text:sub(self.prompt.config.text:len() + 1))
    end,
    done_callback = function()
      self:hide()
    end,
    keypressed_callback = function(mod, key, cmd)
      if mod["Control"] and key == "n" or key == "Down" then
	self.cursor.mod = self.elements.config.count[1]
      elseif mod["Control"] and key == "p" or key == "Up" then
	self.cursor.mod = -self.elements.config.count[1]
      elseif mod["Control"] and key == "f" or key == "Right" then
	self.cursor.mod = 1
      elseif mod["Control"] and key == "b" or key == "Left" then
	self.cursor.mod = -1
      elseif key == "Return" or key == "Tab" then
 	if self.elements.keys[self.results[self.cursor.pos]] then
	  self.elements.keys[self.results[self.cursor.pos]].callback()
	end
      end
      if self.selectedElement and self.selectedElement.keys then
	for k, keybind in pairs(self.selectedElement.keys) do
	  local match = true
	  if key == keybind[2] then
	    for i, modifier in  pairs(keybind[1]) do
	      if not mod[modifier] then
		match = false
		break
	      end
	    end
	    if match then
	      keybind[3]()
	    end
	  end
	end
      end
    end
  })
end

function SearchMenu:initPrompt()
  self.prompt.widget = {}
  self.prompt.widget.bare = wibox.widget.textbox()
  self.prompt.widget.place = wibox.container.place(self.prompt.widget.bare)
  self.prompt.widget.margin = wibox.container.margin(self.prompt.widget.place)
  self.prompt.widget.background = wibox.container.background(self.prompt.widget.margin)
  self.prompt.widget.outsideMargin = wibox.container.margin(self.prompt.widget.background)
  self.prompt.widget.final = self.prompt.widget.outsideMargin
end

function SearchMenu:initElements()
  for i = 1, self.elements.config.count[1] * self.elements.config.count[2] do
    local widget = {}
    widget.text = wibox.widget.textbox()
    widget.showcaseMargin = wibox.container.margin()
    widget.showcaseFinal = widget.showcaseMargin
    widget.textPlace = wibox.container.place(widget.text)
    widget.textFinal = widget.textPlace
    local widgets = {
      layout = wibox.layout.fixed.horizontal,
      widget.showcaseFinal,
      widget.textFinal
    }
    if self.elements.config.showcasePosition == "bottom" or self.elements.config.showcasePosition == "top" then
      widgets.layout = wibox.layout.fixed.vertical
    end
    if self.elements.config.showcasePosition == "bottom" or self.elements.config.showcasePosition == "right" then
      widgets[1] = widget.textFinal
      widgets[2] = widget.showcaseFinal
      if self.elements.config.hideText then
	widgets[1] = nil
      end
    else
      if self.elements.config.hideText then
	widgets[2] = nil
      end
    end
    widget.bare = wibox.widget(widgets)
    widget.place = wibox.container.place(widget.bare)
    widget.margin = wibox.container.margin(widget.place)
    widget.background = wibox.container.background(widget.margin)
    widget.outsideMargin = wibox.container.margin(widget.background)
    widget.final = widget.outsideMargin
    widget.final:connect_signal("mouse::enter", function()
      if i + self.cursor.page * self.elements.config.count[1] * self.elements.config.count[2] > #self.results then
	return
      end
      self.cursor.pos = self.cursor.page * self.elements.config.count[1] * self.elements.config.count[2] + i
      self:redraw()
    end)
    widget.final:connect_signal("button::release", function(args)
      if i + self.cursor.page * self.elements.config.count[1] * self.elements.config.count[2] > #self.results then
	return
      end
      root.fake_input("key_press", "Return")
      root.fake_input("key_release", "Return")
    end)
    self.elements.widgets[i] = widget
  end
  self.elements.boundedWidget = wibox.container.margin(wibox.widget(
    gears.table.join(
      {
	layout = wibox.layout.grid.vertical(self.elements.config.count[1])
      },
      gears.table.map(function(widget) return widget.final end, self.elements.widgets)
    )
  ))
end

function SearchMenu:initWidget()
  if not self.prompt.config.hide then
    self.widget = wibox.widget {
      layout = wibox.layout.fixed.vertical,
      self.prompt.widget.final,
      self.elements.boundedWidget
    }
  else
    self.widget = wibox.widget {
      layout = wibox.layout.fixed.vertical,
      self.elements.boundedWidget
    }
  end
end

function SearchMenu:generateElements(tbl)
  local i = 1
  for key, element in pairs(tbl) do
    self.elements.keys[element.name] = element
    self.elements.names[i] = element.name
    i = i + 1
  end
end

function SearchMenu:refreshTheme()
  self.prompt.widget.place.halign = self.prompt.config.halign
  self.prompt.widget.place.valign = self.prompt.config.valign
  self.prompt.widget.margin.left = self.prompt.config.margins.left
  self.prompt.widget.margin.right = self.prompt.config.margins.right
  self.prompt.widget.margin.top = self.prompt.config.margins.top
  self.prompt.widget.margin.bottom = self.prompt.config.margins.bottom
  self.prompt.widget.background.bg = self.prompt.config.bg
  self.prompt.widget.background.fg = self.prompt.config.fg
  self.prompt.widget.background.shape = self.prompt.config.shape
  self.prompt.widget.outsideMargin.left = self.prompt.config.outsideMargins.left
  self.prompt.widget.outsideMargin.right = self.prompt.config.outsideMargins.right
  self.prompt.widget.outsideMargin.top = self.prompt.config.outsideMargins.top
  self.prompt.widget.outsideMargin.bottom = self.prompt.config.outsideMargins.bottom
  self.prompt.widget.final.forced_width = self.prompt.config.size[1]
  self.prompt.widget.final.forced_height = self.prompt.config.size[2]

  for key, widget in pairs(self.elements.widgets) do
    widget.place.halign = self.elements.config.halign
    widget.textPlace.halign = self.elements.config.halign
    widget.place.valign = self.elements.config.valign
    widget.textPlace.valign = self.elements.config.valign
    widget.margin.left = self.elements.config.margins.left
    widget.margin.right = self.elements.config.margins.right
    widget.margin.top = self.elements.config.margins.top
    widget.margin.bottom = self.elements.config.margins.bottom
    widget.background.bg = self.elements.config.bg
    widget.background.fg = self.elements.config.fg
    widget.background.shape = self.elements.config.shape
    widget.outsideMargin.left = self.elements.config.outsideMargins.left
    widget.outsideMargin.right = self.elements.config.outsideMargins.right
    widget.outsideMargin.top = self.elements.config.outsideMargins.top
    widget.outsideMargin.bottom = self.elements.config.outsideMargins.bottom
    widget.text.font = self.elements.config.font
    widget.final.forced_width = self.elements.config.size[1]
    widget.final.forced_height = self.elements.config.size[2]
  end

  self.elements.boundedWidget.left = self.elements.config.boundMargins.left
  self.elements.boundedWidget.right = self.elements.config.boundMargins.right
  self.elements.boundedWidget.top = self.elements.config.boundMargins.top
  self.elements.boundedWidget.bottom = self.elements.config.boundMargins.bottom
end

function SearchMenu:update(text)
  self.prompt.widget.bare.font = self.prompt.config.font
  text = text:sub(1,-2)
  local results = self.elements.names
  if text:len() > 0 and not self.searchDisabled then
    results = sortByComparison(text, self.elements.names, 0.5)
  end
  self.results = results
  self.cursor.pos = wrapIP(clamp(self.cursor.pos, 1, #results) + self.cursor.mod, 1, #results)
  self.cursor.mod = 0
  local page = clamp(math.ceil(self.cursor.pos / #self.elements.widgets) - 1, 0, false)
  self.cursor.page = page
  self.selectedElement = nil
  self:redraw()
end

function SearchMenu:redraw()
  local placeInvert = {left = "right", right = "left", top = "bottom", bottom = "top"}
  for i = 1, #self.elements.widgets do
    local element = self.elements.keys[self.results[i + self.cursor.page * #self.elements.widgets]]
    local widget = self.elements.widgets[i]
    local isSelected = (self.cursor.pos - self.cursor.page * #self.elements.widgets == i)
    if isSelected then
      self.selectedElement = element
    end
    widget.background.visible = false
    widget.showcaseMargin.widget = nil
    widget.showcaseMargin.margins = 0
    if i + self.cursor.page * #self.elements.widgets <= #self.results then
      if element.update then
	element.update(i, isSelected)
      end
      widget.showcaseMargin.widget = element.showcase or nil
      widget.background.bg = element.bgFunc and element.bgFunc(i, isSelected) or isSelected and self.elements.config.bgHl or self.elements.config.bg
      widget.background.fg = element.fgFunc and element.fgFunc(i, isSelected) or isSelected and self.elements.config.fgHl or self.elements.config.fg
      if not element.hideText and not self.elements.config.hideText then
	widget.showcaseMargin[placeInvert[self.elements.config.showcasePosition]] = self.elements.config.margins[self.elements.config.showcasePosition]
	widget.text.text = element.text or element.name
      else
	widget.text.text = ""
      end
      self.elements.widgets[i].background.visible = true
    end
  end
end

function SearchMenu:setup(args)
  self.screen = args.screen
  self.widget = nil
  self.searchDisabled = args.searchDisabled or false
  --Wibox config
  self.wibox = {
    config = {}
  }

  themer.apply(
    {
      {"size", {200, 300}},
      {"pos", function() return {self.screen.geometry.x + (self.screen.geometry.width - self.wibox.config.size[1]) / 2, self.screen.geometry.y + (args.wibox and args.wibox.offset or 0)} end, true},
      {"margins", margins(0)},
      {"shape", gears.shape.rectangle},
      {"bg", "#000000"},
      {"ontop", true}
    }, beautiful.searchMenu and beautiful.searchMenu.wibox or {}, self.wibox.config
  )

  themer.apply({{"size"}, {"pos"}, {"margins"}, {"shape"}, {"bg"}, {"ontop"}}, args.wibox or {}, self.wibox.config)
		 
  self.prompt = {
    config = {}
  }

  themer.apply(
    {
      {"hide", false},
      {"bg", "#101010"},
      {"fg", "#FFFFFF"},
      {"margins", margins(0)},
      {"outsideMargins", margins(0)},
      {"halign", "center"},
      {"valign", "center"},
      {"font", beautiful.fontName},
      {"text"},
      {"shape", gears.shape.rectangle},
      {"fontSize", 12},
      {"size", function()
	return {
	  self.wibox.config.size[1],
	  self.prompt.config.fontSize * 1.5 + self.prompt.config.margins.top + self.prompt.config.margins.bottom + self.prompt.config.outsideMargins.top + self.prompt.config.outsideMargins.bottom
	}
      end, true}
    }, beautiful.searchMenu and beautiful.searchMenu.prompt or {}, self.prompt.config
  )

  themer.apply({{"hide"}, {"bg"}, {"fg"}, {"margins"}, {"outsideMargins"}, {"halign"}, {"valign"}, {"font"}, {"text"}, {"shape"}, {"fontSize"}, {"size"}}, args.prompt or {}, self.prompt.config)

  self.elements = {
    config = {},
    widgets = {},
    names = {},
    keys = {}
  }

  self.elements.config.bg = args.elements and args.elements.bg or beautiful.searchMenu.elements.bg
  self.elements.config.bgHl = args.elements and args.elements.bgHl or beautiful.searchMenu.elements.bgHl
  self.elements.config.fgHl = args.elements and args.elements.fgHl or beautiful.searchMenu.elements.fgHl
  self.elements.config.fg = args.elements and args.elements.fg or beautiful.searchMenu.elements.fg
  self.elements.config.hideText = args.elements and args.elements.hideText or beautiful.searchMenu.elements.hideText or false
  self.elements.config.margins = args.elements and args.elements.margins or beautiful.searchMenu.elements.margins
  self.elements.config.outsideMargins = args.elements and args.elements.outsideMargins or beautiful.searchMenu.elements.outsideMargins
  self.elements.config.halign = args.elements and args.elements.halign or beautiful.searchMenu.elements.halign
  self.elements.config.valign = args.elements and args.elements.valign or beautiful.searchMenu.elements.valign
  self.elements.config.font = args.elements and args.elements.font or beautiful.searchMenu.elements.font
  self.elements.config.shape = args.elements and args.elements.shape or beautiful.searchMenu.elements.shape
  self.elements.config.showcasePosition = args.elements and args.elements.showcasePosition or "left"
  self.elements.config.fontSize = tonumber(gears.string.split(self.elements.config.font, " ")[2])
  self.elements.config.size = {}
  self.elements.config.size[1] = args.elements and args.elements.size and args.elements.size[1] or beautiful.searchMenu.elements.size and beautiful.searchMenu.elements.size[1] or self.wibox.config.size[1]
  self.elements.config.size[2] = args.elements and args.elements.size and args.elements.size[2] or beautiful.searchMenu.elements.size and beautiful.searchMenu.elements.size[2] or self.elements.config.fontSize * 1.5 + self.elements.config.margins.top + self.elements.config.margins.bottom + self.elements.config.outsideMargins.top + self.elements.config.outsideMargins.bottom
  self.elements.config.count = {math.floor(self.wibox.config.size[1] / self.elements.config.size[1]), math.floor((self.wibox.config.size[2] - self.prompt.config.size[2]) / self.elements.config.size[2])}
  self.elements.config.count[2] = math.floor(self.wibox.config.size[2] / self.elements.config.size[2])
  self.elements.config.boundMargins = {
    left = (self.wibox.config.size[1] - self.elements.config.size[1] * self.elements.config.count[1]) / 2,
    right = (self.wibox.config.size[1] - self.elements.config.size[1] * self.elements.config.count[1]) / 2,
    top = 0,
    bottom = 0
  }

  self.cursor = {
    pos = 1,
    mod = 0,
    page = 0
  }

  self.results = {}
  self.selectedElement = nil

  self:initPrompt()
  self:generateElements(args.elements.list)  self.elements.config.size[1] = args.elements and args.elements.size and args.elements.size[1] or beautiful.searchMenu.elements.size and beautiful.searchMenu.elements.size[1] or self.wibox.config.size[1]
  self:initElements()
  self:initWidget()
  self:refreshTheme()

  self.wibox.widget = wibox({
    ontop = self.wibox.config.ontop,
    x = self.wibox.config.pos[1],
    y = self.wibox.config.pos[2],
    width = self.wibox.config.size[1],
    height = self.wibox.config.size[2],
    bg = self.wibox.config.bg,
    fg = self.wibox.config.fg,
    shape = self.wibox.config.shape,
    widget = self.widget
  })

  return self
end


function SearchMenu:show()
  if self.wibox.widget.visible then
    return
  end
  self.cursor.pos = 1
  self.cursor.page = 0
  self:update("")
  self.wibox.widget.visible = true
  if self.wibox.widget.visible then
    self:runPrompt()
  end
end

function SearchMenu:hide()
  self.wibox.widget.visible = false
end
