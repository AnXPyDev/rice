-- /client.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

-- Sets border size and shape of each client on it's creation

client.connect_signal("manage", function(c)
  c.border_width = beautiful.border_width
  c.border_color = beautiful.bg_normal

	--[[
		This shape function returns a regular rectangle when a client is fullscreen or
		the tag that it's on has no gaps, for obvious reasons, else returns a rounded rectangle
	]]--
	
  c.shape = function(cr, w, h)
    if (c.first_tag.gap == 0 or c.fullscreen) and not c.floating then
      return gears.shape.rectangle(cr, w, h)
    end
    return gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
  end
end)

--[[
	TODO: A function that blinks client on focus (like flashfocus)
]]--

client.connect_signal("focus", function(c) end)

-- Focuses client when mouse enters

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Icons for titlebar buttons

local closeIcon = materializeSurface(gears.surface.load(PATH.icons .. "close.png"), {normal = themeful.titleButton.fg, highlight = themeful.titleButton.fgHl})
local floatIcon = materializeSurface(gears.surface.load(PATH.icons .. "float.png"), {normal = themeful.titleButton.fg, highlight = themeful.titleButton.fgHl})
local tileIcon = materializeSurface(gears.surface.load(PATH.icons .. "tile.png"), {normal = themeful.titleButton.fg, highlight = themeful.titleButton.fgHl})

-- Creates titlebars for each client

client.connect_signal("request::titlebars" ,
  function(c)
		-- Buttons for grabbing and moving/resizing client by the statusbar
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
			-- Left
			{
				layout = wibox.layout.flex.horizontal,
				buttons = buttons
			},
			-- Centers a textbox with the client's name
      {
				{
					align = "center",
					widget = awful.titlebar.widget.titlewidget(c)
				},
				buttons = buttons,
				layout = wibox.layout.flex.horizontal
      },
			-- Right (titlebar buttons)
      {
				-- Creates a tile/float button
				titlebutton:new()
					:setup({
						-- Changes icon based on initial client state
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
							-- Same, but when the client state changes
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

						-- Makes the client tiled/floating based on current state when clicked on, also changes icon
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

				-- Kills client when clicked
				titlebutton:new()
					:setup({
						callback = function(button)
							c:kill()
						end,
						initCallback = function(button)
							button:setIcon(closeIcon)
							button.image.image = button.icon.normal
						end
										}
								).widget,
				layout = wibox.layout.fixed.horizontal
			},
      layout = wibox.layout.align.horizontal

																																								 })
																																									 
end)
