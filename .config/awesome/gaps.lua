-- /gaps.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

--[[
	Cycles throught gap values provided by current theme.
	Only cycles forward and loops when at end !
]]--

function toggleGaps()
  tag = awful.screen.focused().selected_tag
  next = 1
  for i = 1, #themeful.gaps do
    if themeful.gaps[i] == tag.gap then
      next = i + 1
      break
    end
  end
  if #themeful.gaps < next then
    next = 1
  end
  tag.gap = themeful.gaps[next]
	-- Updates layout so the changes take effect
  awful.layout.arrange(awful.screen.focused())
end
