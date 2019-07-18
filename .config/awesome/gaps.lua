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
  awful.layout.arrange(awful.screen.focused())
end
