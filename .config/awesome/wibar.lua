local wibarWidgets = {}
wibarWidgets.clock = wibox.widget.textclock("%H:%M:%S", 1)
wibarWidgets.calendar = wibox.widget.textclock("%d %h")
wibarWidgets.margin = 8

-- local wibar = awful.wibar({
--   screen = screens.primary,
--   visible = true,
--   ontop = false,
--   position = "top",
--   width = screens.primary.geometry.width,
--   height = beautiful.wibar_height,
--   bg = beautiful.wibar_bg,
--   fg = beautiful.fg_focus,
-- }):setup {
--   layout = wibox.layout.align.horizontal,
--   nil,
--   wibox.container.place
--   (
--     wibox.widget {
--       layout = wibox.layout.fixed.horizontal,
--       wibox.container.margin(wibox.widget.imagebox(PATH.home .. "icons/calendar.png"), dpi(wibarWidgets.margin), dpi(wibarWidgets.margin), dpi(wibarWidgets.margin), dpi(wibarWidgets.margin)),
--       wibarWidgets.calendar,
--       wibox.container.margin(wibox.widget.imagebox(PATH.home .. "icons/clock.png"), dpi(wibarWidgets.margin), dpi(wibarWidgets.margin), dpi(wibarWidgets.margin), dpi(wibarWidgets.margin)),
--       wibarWidgets.clock,
--     },
--     "center"
--   ),
--   nil
-- 	 }
