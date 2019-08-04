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
    return gears.shape.rounded_rect(cr, w, h, themeful.radius)
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

local titlebarConfig = {}

themer.apply(
	{
		{"height", dpi(30)},
		{"font", beautiful.font},
		{"bg", "#000000"},
		{"fg", "#FFFFFF"},
		{"bgFocus", "#FFFFFF"},
		{"fgFocus", "#000000"}
	},
	themeful.titleBar or {}, titlebarConfig
)


local titlebuttonsConfig = {}

themer.apply(
  {
    {"shape", themeful.button.shape},
    {"closeBgHover", themeful.button.bgHover},
    {"closeFgHover", themeful.button.fgHover},
    {"closeBgClick", themeful.button.bgClick},
    {"tileBgHover", themeful.button.bgHover},
    {"tileFgHover", themeful.button.fgHover},
    {"tileBgClick", themeful.button.bgClick},
    {"outsideMargins", themeful.button.outsideMargins},
    {"margins", themeful.button.margins}
  },
  themeful.titleButtons or {}, titlebuttonsConfig
)

-- Icons for titlebar buttons

local closeIcon = materializeSurface(gears.surface.load(PATH.icons .. "close.png"), {normal = titlebarConfig.fg, focus = titlebarConfig.fgFocus, highlight = titlebuttonsConfig.closeFgHover})
local floatIcon = materializeSurface(gears.surface.load(PATH.icons .. "float.png"), {normal = titlebarConfig.fg, focus = titlebarConfig.fgFocus, highlight = titlebuttonsConfig.tileFgHover})
local tileIcon = materializeSurface(gears.surface.load(PATH.icons .. "tile.png"), {normal = titlebarConfig.fg, focus = titlebarConfig.fgFocus, highlight = titlebuttonsConfig.tileFgHover})

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

    awful.titlebar(c, {
			size = titlebarConfig.height,
			font = titlebarConfig.font,
			fg_normal = titlebarConfig.fg,
			bg_normal = titlebarConfig.bg,
			fg_focus = titlebarConfig.fgFocus,
			bg_focus = titlebarConfig.bgFocus
		}) : setup({
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
				Button:new()
					:setup({
						-- Changes icon based on initial client state
						initCallback = function(button)
							c:connect_signal("focus", function()
								button.colorAnimation.done = true
								button.config.bg = titlebarConfig.bgFocus
								button.icon.normal = button.currentIcon.focus
								button.background.bg = button.config.bg
								button.image.image = button.icon.normal
							end)
							c:connect_signal("unfocus", function()
								button.colorAnimation.done = true
								button.config.bg = titlebarConfig.bg
								button.icon.normal = button.currentIcon.normal
								button.background.bg = button.config.bg
								button.image.image = button.icon.normal
							end)
							if c.floating then
								button.state = "tile"
								button.currentIcon = tileIcon
							else
								button.state = "float"
								button.currentIcon = floatIcon
							end

							button:setIcon({normal = button.currentIcon.normal, highlight = button.currentIcon.highlight})
							if c.focused then
								button.icon.normal = button.currentIcon.focused
							end
							button.image.image = button.icon.normal

              button.config.bgHover = titlebuttonsConfig.tileBgHover
              button.config.bgClick = titlebuttonsConfig.tileBgClick
              
							-- Same, but when the client state changes
							c:connect_signal("property::floating", function()
								if c.floating then
									button.state = "tile"
									button.currentIcon = tileIcon
									button:setIcon({normal = button.currentIcon.normal, highlight = button.currentIcon.highlight})
									if c.focused then
										button.icon.normal = button.currentIcon.focused
									end
                  if not button.mouseIn then
                    button.image.image = button.icon.normal
                  end
								else
									button.state = "float"
									button:setIcon({normal = floatIcon.normal, highlight = floatIcon.highlight})
									button.currentIcon = floatIcon
									button:setIcon({normal = button.currentIcon.normal, highlight = button.currentIcon.highlight})
									if c.focused then
										button.icon.normal = button.currentIcon.focused
									end
                  if not button.mouseIn then
                    button.image.image = button.icon.normal
                  end
								end
							end)
						end,

						-- Makes the client tiled/floating based on current state when clicked on, also changes icon
						callback = function(button)
							if button.state and button.state == "float" then
								button.state = "tile"
								c.floating = true
							else
								button.state = "float"
								c.floating = false
							end
						end
										}
								).widget,

				-- Kills client when clicked
				Button:new()
					:setup({
						callback = function(button)
							c:kill()
						end,
						initCallback = function(button)
							c:connect_signal("focus", function()
								button.colorAnimation.done = true
								button.config.bg = titlebarConfig.bgFocus
								button.icon.normal = closeIcon.focus
								button.image.image = button.icon.normal
								button.background.bg = button.config.bg
							end)
							c:connect_signal("unfocus", function()
								button.colorAnimation.done = true
								button.config.bg = titlebarConfig.bg
								button.icon.normal = closeIcon.normal
								button.image.image = button.icon.normal
								button.background.bg = button.config.bg
							end)
              button.config.bgHover = titlebuttonsConfig.closeBgHover
              button.config.bgClick = titlebuttonsConfig.closeBgClick
							button:setIcon({normal = closeIcon.normal, highlight = closeIcon.highlight})
							if c.focused then
								button.icon.normal = button.currentIcon.focused
							end
							button.image.image = button.icon.normal
						end
										}
								).widget,
				layout = wibox.layout.fixed.horizontal
			},
      layout = wibox.layout.align.horizontal

																																								 })
																																									 
end)
