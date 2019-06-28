local wibarWidgets = {}
wibarWidgets.clock = wibox.widget.textclock("%H:%M:%S")

local wibar = awful.wibar({
  screen = screens.primary,
  visible = true,
  ontop = false,
  position = "top",
  width = screens.primary.geometry.width,
  height = beautiful.wibar_height,
  bg = beautiful.wibar_bg,
  fg = beautiful.fg_focus,
}):setup {
  layout = wibox.layout.align.horizontal,
  {
    layout = wibox.layout.fixed.horizontal
  },
  {
    layout = wibox.layout.fixed.horizontal
  },
  {
    layout = wibox.layout.fixed.horizontal,
    wibox.container.margin(wibox.widget.imagebox(PATH.home .. "icons/clock.png"), dpi(10), dpi(6), dpi(6), dpi(6)),
    wibarWidgets.clock,
    wibox.container.margin(nil, dpi(10))
  }
	 }
