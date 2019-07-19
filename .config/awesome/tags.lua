tags = {
  names = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},
  per = 3,
  list = {},
  selected = nil
}

for i = 1, #screens.list do
  tempTagNames = {}
  for e = i * (tags.per - 1), i * (tags.per - 1) + (tags.per - 1) do
    tempTagNames = gears.table.join(tempTagNames, {tags.names[e]})
  end
  tags.list = gears.table.join(tags.list, awful.tag.new(tempTagNames, screens.list[i], awful.layout.layouts[1]))
end

tags.selected = tags.list[1]

function tags.select(n)
  tags.selected = tags.list[clamp(n, 1, #tags.list)]
  tags.selected:view_only()
	local clients = tags.selected:clients()
	if #clients > 0 then
		clients[1]:jump_to()
	end
end
