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
  local elements = {}
  for i = 1, #self.elementTexts do
    elements[i] = self.elementWidgets[self.elementTexts[i]]
  end
  local containedElements = wibox.widget(gears.table.join(elements, {
    layout = wibox.layout.fixed.vertical
  }))
  self.widget = wibox.widget {
    containedTextbox,
    containedElements,
    layout = wibox.layout.fixed.vertical
  }
end

function SearchMenu:initElements()
  for i = 1, #self.elements do
    self.elementTexts[i] = self.elements[i].name
    local containedWidget = wibox.widget.textbox(self.elementTexts[i])
    containedWidget.font = self.elementFont
    containedWidget = wibox.container.margin(containedWidget)
    containedWidget.margins = self.padding
    containedWidget = wibox.container.background(containedWidget)
    containedWidget.bg = self.bg
    self.elementWidgets[self.elementTexts[i]] = containedWidget
  end
end

function SearchMenu:update(text)
  log(text)
end

function SearchMenu:setup(args)
  self.screen = args.screen
  self.size = args.size
  self.pos = {self.screen.geometry.x + (self.screen.geometry.width - self.size[1]) / 2, self.screen.geometry.y + args.offset}
  self.mult = {0.8, 0.8}
  self.promptSize = args.promptSize or {self.size[1] * self.mult[1], self.size[2] * self.mult[2]}
  self.promptBg = args.promptBg or beautiful.searchMenu_promptBg
  self.widget = nil
  self.textbox = nil
  self.prompt = ""
  self.padding = args.padding or dpi(10)
  self.promptFont = args.promptFont or beautiful.searchMenu_promptFont
  self.elementFont = args.elementFont or beautiful.searchMenu_elementFont
  self.type = args.type or "lines"
  self.elements = args.elements
  self.elementWidgets = {}
  self.elementContainer = nil
  self.elementTexts = {}
  self:initWidgets()
  self.wibox = wibox({
    ontop = true,
    x = self.pos[1],
    y = self.pos[2],
    width = self.size[1],
    height = self.size[2],
    bg = args.bg or beautiful.searchMenu_bg or beautiful.bg_normal,
    fg = args.fg or beautiful.searchMenu_fg or beautiful.fg_normal,
    shape = self.shape,
    widget = self.widget
  })
  return self
    
end

function SearchMenu:show()
  if self.wibox.visible then
    return
  end
  self.wibox.visible = true
  if self.wibox.visible then
    self:runPrompt()
  end
end

function SearchMenu:hide()
  self.wibox.visible = false
end

testMenu = SearchMenu:new():setup({
  screen = screens.primary,
  size = {dpi(400), dpi(200)},
  offset = dpi(10),
  padding = dpi(10),
  elements = {
    {name = "Firefox"},
    {name = "Emacs"},
    {name = "TeamSpeak"}
  }
})
