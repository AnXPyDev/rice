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

end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

local closeIcon = materializeSurface(gears.surface.load(PATH.home .. "icons/close.png"), {normal = themeful.titleButton.fg, highlight = themeful.titleButton.fgHl})
local floatIcon = materializeSurface(gears.surface.load(PATH.home .. "icons/float.png"), {normal = themeful.titleButton.fg, highlight = themeful.titleButton.fgHl})
local tileIcon = materializeSurface(gears.surface.load(PATH.home .. "icons/tile.png"), {normal = themeful.titleButton.fg, highlight = themeful.titleButton.fgHl})

client.connect_signal("request::titlebars" ,
  function(c)
		local buttons = gears.table.join(
			awful.button({ }, 1, function()
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
			end),
			awful.button({ }, 3, function()
				client.focus = c
				c:raise()
				awful.mouse.client.resize(c)
			end)
		)
    awful.titlebar(c, {size = beautiful.titlebar_size, position = "top"}) : setup({
			{
				layout = wibox.layout.flex.horizontal,
				buttons = buttons
			},
      {
				{
					align = "center",
					widget = awful.titlebar.widget.titlewidget(c)
				},
				buttons = buttons,
				layout = wibox.layout.flex.horizontal
      },
      {
				titlebutton:new()
					:setup({
						initCallback = function(button)
							if c.floating then
								button.state = "tile"
								button:setIcon(tileIcon)
								button.image.image = button.icon.normal
							else
								button.state = "float"
								button:setIcon(floatIcon)
								button.image.image = button.icon.normal
							end
							c:connect_signal("property::floating", function()
								if c.floating then
									button.state = "tile"
									button:setIcon(tileIcon)
									button.image.image = button.icon.normal
									c.floating = true
								else
									button.state = "float"
									button:setIcon(floatIcon)
									button.image.image = button.icon.normal
									c.floating = false
								end
							end)
						end,
						callback = function(button)
							if button.state and button.state == "float" then
								button.state = "tile"
								button:setIcon(tileIcon)
								button.background.bg = button.config.bg
								button.image.image = button.icon.normal
								c.floating = true
							else
								button.state = "float"
								button:setIcon(floatIcon)
								button.background.bg = button.config.bg
								button.image.image = button.icon.normal
								c.floating = false
							end
						end
										}
								).widget,
				titlebutton:new()
					:setup({
						callback = function(button)
							c:kill()
						end,
						initCallback = function(button)
							button:setIcon(closeIcon)
						end
										}
								).widget,
				layout = wibox.layout.fixed.horizontal
			},
      layout = wibox.layout.align.horizontal

																																								 })
																																									 
end)
