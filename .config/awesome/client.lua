client.connect_signal("manage", function(c)
  c.shape = gears.shape.rectangle
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("request::titlebars" , function(c)
  awful.titlebar(c, {size = beautiful.titlebar_size}) : setup({
    nil,
    {
      {
	align = "center",
	widget = awful.titlebar.widget.titlewidget(c)
      },
      layout = wibox.layout.flex.horizontal
    },
    nil,
    layout = wibox.layout.align.horizontal
										    })
end)
