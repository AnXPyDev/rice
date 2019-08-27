-- /rules.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

awful.rules.rules = {
  {
    rule = {},
    properties = {
			-- Disables ugly gaps between terminals
      size_hints_honor = false,
      focus = true,
      keys = keys.client,
      buttons = buttons.client,
      tag = function() return tags.selected end,
      titlebars_enabled = true
    }
  }
}
