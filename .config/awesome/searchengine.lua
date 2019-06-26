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
    changed_callback = function()
      self.prompt.widget.bare.font = self.prompt.config.font
      self:update(self.prompt.widget.bare.text:sub(self.prompt.config.text:len() + 1))
    end,
    done_callback = function()
      self:hide()
    end,
    keypressed_callback = function(mod, key, cmd)
      if mod["Control"] and key == "n" then
	self.cursor.mod = 1
      elseif mod["Control"] and key == "p" then
	self.cursor.mod = -1
      elseif key == "Return" then
	self.elements.keys[self.results[self.cursor.pos]].callback()
      end
    end
  })
  self.prompt.widget.bare.font = self.prompt.config.fonts
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
  for i = 1, self.elements.config.count do
    local widget = {}
    widget.bare = wibox.widget.textbox()
    widget.place = wibox.container.place(widget.bare)
    widget.margin = wibox.container.margin(widget.place)
    widget.background = wibox.container.background(widget.margin)
    widget.outsideMargin = wibox.container.margin(widget.background)
    widget.final = widget.outsideMargin
    self.elements.widgets[i] = widget
  end
end

function SearchMenu:initWidget()
  self.widget = wibox.widget(
    gears.table.join(
      {
	layout = wibox.layout.fixed.vertical,
	self.prompt.widget.final
      },
      gears.table.map(function(widget) return widget.final end, self.elements.widgets)
    )
  )
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
  self.prompt.widget.outsideMargin.left = self.prompt.config.outsideMargins.left
  self.prompt.widget.outsideMargin.right = self.prompt.config.outsideMargins.right
  self.prompt.widget.outsideMargin.top = self.prompt.config.outsideMargins.top
  self.prompt.widget.outsideMargin.bottom = self.prompt.config.outsideMargins.bottom
  self.prompt.widget.bare.font = self.prompt.config.font
  self.prompt.widget.final.forced_width = self.prompt.config.size[1]
  self.prompt.widget.final.forced_height = self.prompt.config.size[2]

  for key, widget in pairs(self.elements.widgets) do
    widget.place.halign = self.elements.config.halign
    widget.place.valign = self.elements.config.valign
    widget.margin.left = self.elements.config.margins.left
    widget.margin.right = self.elements.config.margins.right
    widget.margin.top = self.elements.config.margins.top
    widget.margin.bottom = self.elements.config.margins.bottom
    widget.background.bg = self.elements.config.bg
    widget.background.fg = self.elements.config.fg
    widget.outsideMargin.left = self.elements.config.outsideMargins.left
    widget.outsideMargin.right = self.elements.config.outsideMargins.right
    widget.outsideMargin.top = self.elements.config.outsideMargins.top
    widget.outsideMargin.bottom = self.elements.config.outsideMargins.bottom
    widget.bare.font = self.elements.config.font
    widget.final.forced_width = self.elements.config.size[1]
    widget.final.forced_height = self.elements.config.size[2]

  end
end

function SearchMenu:update(text)
  text = text:sub(1,-2)
  local results = self.elements.names
  if text:len() > 0 then
    results = sortByComparison(text, self.elements.names, 0.5)
  end
  self.results = results
  self.cursor.pos = wrapIP(clamp(self.cursor.pos, 1, #results) + self.cursor.mod, 1, #results)
  self.cursor.mod = 0
  local page = clamp(math.ceil(self.cursor.pos / #self.elements.widgets) - 1, 0, false)
  self.cursor.page = page
  for i = 1, #self.elements.widgets do
    self.elements.widgets[i].background.bg = self.elements.config.bg
    self.elements.widgets[i].background.fg = self.elements.config.fg
    if i + page * #self.elements.widgets <= #results then
      self.elements.widgets[i].bare.text = results[i + page * #self.elements.widgets]
    else
      self.elements.widgets[i].bare.text = ""
    end
  end
  if #results > 0 then
    self.elements.widgets[self.cursor.pos - page * #self.elements.widgets].background.bg = self.elements.config.bgHl
    self.elements.widgets[self.cursor.pos - page * #self.elements.widgets].background.fg = self.elements.config.fgHl   
  end
end

function SearchMenu:setup(args)
  self.screen = args.screen
  self.widget = nil

  --Wibox config
  self.wibox = {
    config = {}
  }
  self.wibox.config.size = args.wibox and args.wibox.size or beautiful.searchMenu.wibox.size
  self.wibox.config.pos = args.wibox and args.wibox.pos or {self.screen.geometry.x + (self.screen.geometry.width - self.wibox.config.size[1]) / 2, self.screen.geometry.y + (args.wibox and args.wibox.offset or 0)}
  self.wibox.config.margins = args.wibox and args.wibox.margins or beautiful.searchMenu.wibox.margins
  self.wibox.config.shape = args.wibox and args.wibox.shape or beautiful.searchMenu.wibox.shape or gears.shape.rectangle
  self.wibox.config.bg = args.wibox and args.wibox.bg or beautiful.searchMenu.wibox.bg
  self.wibox.config.bg = args.wibox and args.wibox.bg or beautiful.searchMenu.wibox.bg
  self.wibox.config.ontop = args.wibox and args.wibox.ontop or true
  
  -- Prompt config
  self.prompt = {
    config = {}
  }

  self.prompt.config.bg = args.prompt and args.prompt.bg or beautiful.searchMenu.prompt.bg
  self.prompt.config.fg = args.prompt and args.prompt.fg or beautiful.searchMenu.prompt.fg
  self.prompt.config.margins = args.prompt and args.prompt.margins or beautiful.searchMenu.prompt.margins
  self.prompt.config.outsideMargins = args.prompt and args.prompt.outsideMargins or beautiful.searchMenu.prompt.outsideMargins
  self.prompt.config.halign = args.prompt and args.prompt.halign or beautiful.searchMenu.prompt.halign
  self.prompt.config.valign = args.prompt and args.prompt.valign or beautiful.searchMenu.prompt.valign
  self.prompt.config.font = args.prompt and args.prompt.font or beautiful.searchMenu.prompt.font
  self.prompt.config.text = args.prompt and args.prompt.text or beautiful.searchMenu.prompt.text
  self.prompt.config.fontSize = tonumber(gears.string.split(self.prompt.config.font, " ")[2])
  self.prompt.config.size = {
    self.wibox.config.size[1],
    self.prompt.config.fontSize * 1.5 + self.prompt.config.margins.top + self.prompt.config.margins.bottom + self.prompt.config.outsideMargins.top + self.prompt.config.outsideMargins.bottom
  }

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
  self.elements.config.margins = args.elements and args.elements.margins or beautiful.searchMenu.elements.margins
  self.elements.config.outsideMargins = args.elements and args.elements.outsideMargins or beautiful.searchMenu.elements.outsideMargins
  self.elements.config.halign = args.elements and args.elements.halign or beautiful.searchMenu.elements.halign
  self.elements.config.valign = args.elements and args.elements.valign or beautiful.searchMenu.elements.valign
  self.elements.config.font = args.elements and args.elements.font or beautiful.searchMenu.elements.font
  self.elements.config.fontSize = tonumber(gears.string.split(self.elements.config.font, " ")[2])
  self.elements.config.size = {
    self.wibox.config.size[1],
    self.elements.config.fontSize * 1.5 + self.elements.config.margins.top + self.elements.config.margins.bottom + self.elements.config.outsideMargins.top + self.elements.config.outsideMargins.bottom
  }
  self.elements.config.count = math.floor((self.wibox.config.size[2] - self.prompt.config.size[2]) / self.elements.config.size[2])

  self.cursor = {
    pos = 1,
    mod = 0,
    page = 0
  }
  
  self.lastResults = {}

  self:initPrompt()
  self:generateElements(args.elements.list)
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
  self:update("")
  self.wibox.widget.visible = true
  if self.wibox.widget.visible then
    self:runPrompt()
  end
end

function SearchMenu:hide()
  self.wibox.widget.visible = false
end
