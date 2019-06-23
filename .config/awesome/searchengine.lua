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

function SearchMenu:initWidgets()
  self.prompt = awful.widget.prompt({
    prompt = "Choose: "
  })
  self.widget = self.prompt
end

function SearchMenu:setup(args)
  self.screen = args.screen
  self.size = args.size
  self.pos = {self.screen.geometry.x + (self.screen.geometry.width - self.size[1]) / 2, self.screen.geometry.y + args.offset}
  self.mult = {0.8, 0.8}
  self.promptSize = args.promptSize or {self.size[1] * self.mult[1], self.size[2] * self.mult[2]}
  self.widget = nil
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

function SearchMenu:toggle()
  self.wibox.visible = not self.wibox.visible
  if self.wibox.visible then
    self.prompt:run()
  end
end

testMenu = SearchMenu:new():setup({
  screen = screens.primary,
  size = {300, 50},
  offset = 10
})
