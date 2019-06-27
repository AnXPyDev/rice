client.connect_signal("manage", function(c)
  c.shape = function(cr, w, h)
    if (c.first_tag.gap == 0 or c.fullscreen) and not c.floating then
      return gears.shape.rectangle(cr, w, h)
    end
    return gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, beautiful.corner_radius)
  end
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("request::titlebars" , function(c)
  awful.titlebar(c, {size = beautiful.titlebar_size, position = "left"}) : setup({
    nil,
    nil,
    nil,
    layout = wibox.layout.align.horizontal
										    })
end)
