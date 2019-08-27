-- /tags.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

tags = {
  names = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
  per = 3,
  list = {},
  selected = nil
}

-- Creates tags for every screen
for i = 1, #screens.list do
  tempTagNames = {}
  for e = i * (tags.per - 1), i * (tags.per - 1) + (tags.per - 1) do
    tempTagNames = gears.table.join(tempTagNames, {tags.names[e]})
  end
	-- Adds tag to tags.list
  tags.list = gears.table.join(tags.list, awful.tag.new(tempTagNames, screens.list[i], awful.layout.layouts[1]))
end

-- The selected tag is the one on which clients spawn by default
tags.selected = tags.list[1]

function tags.select(n)
  tags.selected = tags.list[clamp(n, 1, #tags.list)]
  tags.selected:view_only()
	-- Focuses the tags first client if exists
	local clients = tags.selected:clients()
	if #clients > 0 then
		awful.client.focus.byidx(0, clients[1])
	end
	tagindicator:update()
end
