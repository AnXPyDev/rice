client.connect_signal("manage", function(c)
  c.shape = function(cr, w, h)
    if (c.first_tag.gap == 0 and not c.floating) or c.fullscreen then
      return gears.shape.rectangle(cr, w, h)
    else
      return gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
    end
  end
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
