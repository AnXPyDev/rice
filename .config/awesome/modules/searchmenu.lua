-- /modules/searchmenu.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

SearchMenu = {}

-- Creates new SearchMenu

function SearchMenu:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

-- Runs a prompt on the SearchMenu's prompt textbox

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

		-- Loops through default and selected element's keybindings and runs them if necessary
    keypressed_callback = function(mod, key, cmd)
			mod["any"] = true
			for p, bindings in pairs({self.bindings, self.selectedElement and self.selectedElement.bindings or {}}) do
				for k, keybind in pairs(bindings) do
					local match = true
					if key == keybind[2] then
						for i, modifier in pairs(keybind[1]) do
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

-- Creates prompt widget

function SearchMenu:initPrompt()
  self.prompt.widget = {}
  self.prompt.widget.bare = wibox.widget.textbox()
  self.prompt.widget.place = wibox.container.place(self.prompt.widget.bare)
  self.prompt.widget.margin = wibox.container.margin(self.prompt.widget.place)
  self.prompt.widget.background = wibox.container.background(self.prompt.widget.margin)
  self.prompt.widget.outsideMargin = wibox.container.margin(self.prompt.widget.background)
  self.prompt.widget.final = self.prompt.widget.outsideMargin
end

-- Creates widget for the maximum amount of elements that can fit on the screen

function SearchMenu:initElements()
	if self.elements.config.animate then
		self.elements.colorAnimations = {}
		self.elements.animatedColors = {}
	end

  for i = 1, self.elements.config.count[1] * self.elements.config.count[2] do

		if self.elements.config.animate then
			self.elements.colorAnimations[i] = {}
			self.elements.animatedColors[i] = colors.new(self.elements.config.bg)
		end
		
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
  local widget = {}
  widget.bare = wibox.widget(
    gears.table.join(
      {
	layout = wibox.layout {
	  forced_num_cols = self.elements.config.count[1],
	  forced_nim_rows = self.elements.config.count[2],
	  homogenous = false,
	  layout = wibox.layout.grid
	}
      },
      gears.table.map(function(widget) return widget.final end, self.elements.widgets)
    )
  )
  widget.margin = wibox.container.margin(widget.bare)
  widget.margin.forced_width = self.elements.config.size[1] * self.elements.config.count[1] + self.elements.config.boundedMargins.left + self.elements.config.boundedMargins.right
  widget.margin.forced_height = self.elements.config.size[2] * self.elements.config.count[2] + self.elements.config.boundedMargins.top + self.elements.config.boundedMargins.bottom
  widget.place = wibox.container.place(widget.margin)
  widget.final = widget.place
  self.elements.widget = widget
end

-- Joins widgets

function SearchMenu:initWidget()
  if not self.prompt.config.hide then
    self.widget = wibox.widget {
      layout = wibox.layout.fixed.vertical,
      self.prompt.widget.final,
      self.elements.widget.final
    }
  else
    self.widget = wibox.widget {
      layout = wibox.layout.fixed.vertical,
      self.elements.widget.final
    }
  end
end

-- Places all elements into an indexable table

function SearchMenu:generateElements(tbl)
  local i = 1
  for key, element in pairs(tbl) do
    self.elements.keys[element.name] = element
    self.elements.names[i] = element.name
    i = i + 1
  end
end

-- Refreshes theme

function SearchMenu:refreshTheme()
  self.prompt.widget.place.halign = self.prompt.config.halign
  self.prompt.widget.place.valign = self.prompt.config.valign
  gears.table.crush(self.prompt.widget.margin, self.prompt.config.margins)
  self.prompt.widget.background.bg = self.prompt.config.bg
  self.prompt.widget.background.fg = self.prompt.config.fg
  self.prompt.widget.background.shape = self.prompt.config.shape
  gears.table.crush(self.prompt.widget.outsideMargin, self.prompt.config.outsideMargins)
  self.prompt.widget.final.forced_width = self.prompt.config.size[1]
  self.prompt.widget.final.forced_height = self.prompt.config.size[2]

  for key, widget in pairs(self.elements.widgets) do
    widget.place.halign = self.elements.config.halign
    widget.textPlace.halign = self.elements.config.halign
    widget.place.valign = self.elements.config.valign
    widget.textPlace.valign = self.elements.config.valign
    gears.table.crush(widget.margin, self.elements.config.margins)
    widget.background.bg = self.elements.config.bg
    widget.background.fg = self.elements.config.fg
    widget.background.shape = self.elements.config.shape
    gears.table.crush(widget.showcaseMargin, self.elements.config.showcaseMargins)
    gears.table.crush(widget.outsideMargin, self.elements.config.outsideMargins)
    widget.text.font = self.elements.config.font
    widget.final.forced_width = self.elements.config.size[1]
    widget.final.forced_height = self.elements.config.size[2]
  end

  gears.table.crush(self.elements.widget.margin, self.elements.config.boundedMargins)
  self.elements.widget.place.halign = self.elements.config.boundedHalign
  self.elements.widget.place.valign = self.elements.config.boundedValign
end

-- Updates selection of elements when text in prompt changes

function SearchMenu:update(text)
  self.prompt.widget.bare.font = self.prompt.config.font
  text = text:sub(1,-2)
  local results = self.elements.names
  if text:len() > 0 and not self.searchDisabled then
		-- Sorts all the elements by comparison with entered text
    results = sortByComparison(text, self.elements.names, 0.5)
  end
  self.results = results
	-- Wraps cursor around available positions
  self.cursor.pos = wrapIP(clamp(self.cursor.pos, 1, #results) + self.cursor.mod, 1, #results)
  self.cursor.mod = 0
	-- Calculates page, that the cursor is on
  local page = clamp(math.ceil(self.cursor.pos / #self.elements.widgets) - 1, 0, false)
  self.cursor.page = page
  self.selectedElement = nil
  self:redraw()
end

-- Redraws all the widgets (changes text and icons)
-- If a widget is not used, it will be hidden

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
			local newBg = element.bgFunc and element.bgFunc(i, isSelected) or isSelected and self.elements.config.bgHl or self.elements.config.bg

			if self.elements.config.animate and self.elements.animatedColors[i]:to_rgb() ~= newBg then
				self.elements.colorAnimations[i].done = true
				self.elements.colorAnimations[i] = animate.addColor({
					element = widget.background,
					color = self.elements.animatedColors[i],
					targetColor = colors.new(newBg),
					hue = newBg == self.elements.config.bg and "color" or "target",
					amplitude = 0.3
				})
			else
				widget.background.bg = newBg
			end
						

      widget.background.fg = element.fgFunc and element.fgFunc(i, isSelected) or isSelected and self.elements.config.fgHl or self.elements.config.fg
      gears.table.crush(widget.showcaseMargin, self.elements.config.showcaseMargins)
      if not element.hideText and not self.elements.config.hideText then
	widget.text.text = element.text or element.name
      else
	widget.text.text = ""
      end
      self.elements.widgets[i].background.visible = true
    end
  end
end

-- Initializes SearchMenu

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
    }, themeful.searchMenu and themeful.searchMenu.wibox or {}, self.wibox.config
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
    }, themeful.searchMenu and themeful.searchMenu.prompt or {}, self.prompt.config
  )


  themer.apply({{"hide"}, {"bg"}, {"fg"}, {"margins"}, {"outsideMargins"}, {"halign"}, {"valign"}, {"font"}, {"text"}, {"shape"}, {"fontSize"}, {"size"}}, args.prompt or {}, self.prompt.config)

  self.elements = {
    config = {},
    widgets = {},
    names = {},
    keys = {}
  }

  themer.apply(
    {
      {"bg", "#000000"},
      {"bgHl", "#FFFFFF"},
      {"fgHl", "#000000"},
      {"fg", "#FFFFFF"},
      {"hideText", false},
      {"margins", margins(0)},
      {"outsideMargins", margins(0)},
      {"showcaseMargins", margins(0)},
      {"halign", "center"},
      {"valign", "center"},
      {"font", "nvm"},
      {"shape", gears.shape.rectangle},
      {"showcasePosition", "left"},
      {"fontSize", function() return tonumber(gears.string.split(self.elements.config.font, " ")[2]) end, true},
      {"boundedMargins", margins(0)},
      {"boundedHalign", "center"},
      {"boundedValign", "center"},
			{"animate", false}
    }, themeful.searchMenu and themeful.searchMenu.elements, self.elements.config
  )
  themer.apply(
    {
      {"bg"}, {"bgHl"}, {"fgHl"}, {"fg"}, {"hideText"}, {"margins"}, {"outsideMargins"}, {"showcaseMargins"}, {"halign"}, {"valign"}, {"font"}, {"shape"}, {"showcasePosition"}, {"fontSize"}, {"boundedMargins"}, {"boundedHalign"}, {"boundedValign"}, {"animate"}
    }, args.elements, self.elements.config
  )
	
  self.elements.config.size = {}
  self.elements.config.size[1] = args.elements and args.elements.size and args.elements.size[1] or beautiful.searchMenu.elements.size and beautiful.searchMenu.elements.size[1] or self.wibox.config.size[1]
  self.elements.config.size[2] = args.elements and args.elements.size and args.elements.size[2] or beautiful.searchMenu.elements.size and beautiful.searchMenu.elements.size[2] or self.elements.config.fontSize * 1.5 + self.elements.config.margins.top + self.elements.config.margins.bottom + self.elements.config.outsideMargins.top + self.elements.config.outsideMargins.bottom

	-- Calculates ammount of widgets that fit into the wibox
	self.elements.config.count = {
    math.floor((self.wibox.config.size[1] - (self.elements.config.boundedMargins.left + self.elements.config.boundedMargins.right)) / self.elements.config.size[1]),
    math.floor(((self.wibox.config.size[2] - self.prompt.config.size[2]) - (self.elements.config.boundedMargins.top + self.elements.config.boundedMargins.bottom)) / self.elements.config.size[2])
  }

  self.cursor = {
    pos = 1,
    mod = 0,
    page = 0
  }

	self.bindings = {
		{{"Mod1"}, "n", function() self.cursor.mod = self.elements.config.count[1] end},
		{{"Mod1"}, "p", function() self.cursor.mod = - self.elements.config.count[1] end},
		{{"Mod1"}, "o", function() self.cursor.mod = 1 end},
		{{"Mod1"}, "b", function() self.cursor.mod = -1 end},
		{{"any"}, "Down", function() self.cursor.mod = self.elements.config.count[1] end},
		{{"any"}, "Up", function() self.cursor.mod = - self.elements.config.count[1] end},
		{{"any"}, "Left", function() self.cursor.mod = -1 end},
		{{"any"}, "Right", function() self.cursor.mod = 1 end},
		{{"any"}, "Return",
			function()
				if self.selectedElement then
					self.selectedElement.callback()
				end
			end
		},
		{{"any"}, "Tab",
			function()
				if self.selectedElement then
					self.selectedElement.callback()
				end
			end
		}
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
