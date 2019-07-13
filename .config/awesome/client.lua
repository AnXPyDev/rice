client.connect_signal("manage", function(c)
  c.border_width = beautiful.border_width
  c.border_color = beautiful.bg_normal
  c.shape = function(cr, w, h)
    if (c.first_tag.gap == 0 or c.fullscreen) and not c.floating then
      return gears.shape.rectangle(cr, w, h)
    end
    return gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
  end
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.bg_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.bg_normal
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("request::titlebars" ,
  function(c)
    awful.titlebar(c, {size = beautiful.titlebar_size, position = "top"}) : setup({
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
