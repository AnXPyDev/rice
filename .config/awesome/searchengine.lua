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
    textbox = self.textbox,
    prompt = self.prompt,
    changed_callback = function()
      self.textbox.font = self.promptFont
      self:update(self.textbox.text:sub(self.prompt:len() + 1))
    end,
    done_callback = function()
      self:hide()
    end,
    keypressed_callback = function(mod, key, cmd)
      if mod["Control"] and key == "n" then
	self.cursorMod = 1
      elseif mod["Control"] and key == "p" then
	self.cursorMod = -1
      elseif key == "Return" then
	for i = 1, #self.elements.names do
	  if self.elements.names[i] == self.lastResults[self.cursorPos] then
	    if self.elements.og[i].callback then
	      self.elements.og[i].callback()
	      break
	    end
	  end
	end
      end
    end
  })
  self.textbox.font = self.promptFont
end

function SearchMenu:initWidgets()
  self.textbox = wibox.widget.textbox()
  self.textbox.font = beautiful.searchMenu_promptFont
  local containedTextbox = wibox.container.margin(wibox.container.place(self.textbox))
  containedTextbox.margins = self.padding
  containedTextbox = wibox.container.background(
    containedTextbox,
    self.promptBg
  )
  self:initElements()
  local containedElements = wibox.widget(gears.table.join(self.elements.widgets, {layout = wibox.layout.fixed.vertical}))
  self.widget = wibox.widget {
    containedTextbox,
    containedElements,
    layout = wibox.layout.fixed.vertical
  }
end

function SearchMenu:initElements()
  local elementSize = {self.size[1], self.elementFontSize * 1.5 + self.padding * 2}
  local promptSize = {self.size[1], self.promptFontSize * 1.5 + self.padding * 2}
  local numberOfElements = math.floor((self.size[2] - promptSize[2]) / elementSize[2])
  for i = 1, #self.elements.og do
    self.elements.names[i] = self.elements.og[i].name
  end
  for i = 1, numberOfElements do
    self.elements.textboxes[i] = wibox.widget.textbox("Better of dying")
    self.elements.textboxes[i].font = self.elementFont
    local containedWidget = wibox.container.margin(self.elements.textboxes[i])
    containedWidget.margins = self.padding
    containedWidget = wibox.container.background(containedWidget)
    containedWidget.bg = self.elementNormal
    containedWidget.forced_height = elementSize[2]
    self.elements.widgets[i] = containedWidget
  end
end

function SearchMenu:update(text)
  text = text:sub(1,-2)
  local results = self.elements.names
  if text:len() > 0 then
    results = sortByComparison(text, self.elements.names, 0.5)
  end
  self.lastResults = results
  self.cursorPos = wrapIP(clamp(self.cursorPos, 1, #results) + self.cursorMod, 1, #results)
  self.cursorMod = 0
  local page = clamp(math.ceil(self.cursorPos / #self.elements.widgets) - 1, 0, false)
  for i = 1, #self.elements.textboxes do
    self.elements.widgets[i].bg = self.elementNormal
    self.elements.widgets[i].fg = self.elementNormalFg
    if i + page * #self.elements.widgets <= #results then
      self.elements.textboxes[i].text = results[i + page * #self.elements.widgets]
    else
      self.elements.textboxes[i].text = ""
    end
  end
  if #results > 0 then
    self.elements.widgets[self.cursorPos - page * #self.elements.widgets].bg = self.elementHighlight
    self.elements.widgets[self.cursorPos - page * #self.elements.widgets].fg = self.elementHighlightFg    
  end
end

function SearchMenu:setup(args)
  self.screen = args.screen
  self.size = args.size
  self.pos = {self.screen.geometry.x + (self.screen.geometry.width - self.size[1]) / 2, self.screen.geometry.y + args.offset}
  self.promptBg = args.promptBg or beautiful.searchMenu_promptBg
  self.widget = nil
  self.textbox = nil
  self.prompt = ""
  self.cursorPos = 1
  self.cursorMod = 0
  self.lastResults = {}
  self.padding = args.padding or dpi(10)
  self.bg = args.bg or beautiful.searchMenu_bg or beautiful.bg_normal
  self.fg = args.fg or beautiful.searchMenu_fg or beautiful.fg_normal
  self.promptFont = args.promptFont or beautiful.searchMenu_promptFont
  self.promptFontSize = tonumber(gears.string.split(self.promptFont, " ")[2])  
  self.elementFont = args.elementFont or beautiful.searchMenu_elementFont
  self.elementFontSize = tonumber(gears.string.split(self.elementFont, " ")[2])
  self.elementNormal = args.elementNormal or beautiful.searchMenu_elementNormal or self.bg
  self.elementHighlight = args.elementHighlight or beautiful.searchMenu_elementHighlight or self.promptBg
  self.elementHighlightFg = args.elementHighlightFg or beautiful.searchMenu_elementHighlightFg or self.bg
  self.elementNormalFg = args.elementNormalFg or beautiful.searchMenu_elementNormalFg or self.fg  
  self.type = args.type or "lines"
  self.elements = {}
  self.elements.og = args.elements
  self.elements.names = {}
  self.elements.textboxes = {}
  self.elements.widgets = {}
  self:initWidgets()
  self.wibox = wibox({
    ontop = true,
    x = self.pos[1],
    y = self.pos[2],
    width = self.size[1],
    height = self.size[2],
    bg = self.bg,
    fg = self.fg,
    shape = self.shape,
    widget = self.widget
  })
  return self
    
end

function SearchMenu:show()
  if self.wibox.visible then
    return
  end
  self.cursorPos = 1
  self:update("")
  self.wibox.visible = true
  if self.wibox.visible then
    self:runPrompt()
  end
end

function SearchMenu:hide()
  self.wibox.visible = false
end
