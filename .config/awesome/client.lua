client.connect_signal("manage", function(c)
  c.shape = function(cr, w, h)
    if (c.first_tag.gap == 0 or c.fullscreen) and not c.floating then
      return gears.shape.rectangle(cr, w, h)
    end
    --return gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
    return gears.shape.rectangle(cr, w, h)
  end
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("request::titlebars" , function(c)
  awful.titlebar(c, {size = beautiful.titlebar_size, position = "top"}) : setup({
    nil,
    nil,
    nil,
    layout = wibox.layout.align.horizontal
										    })
end)
