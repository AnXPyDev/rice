function toggleGaps()
  tag = awful.screen.focused().selected_tag
  next = 1
  for i = 1, #beautiful.gaps do
    if beautiful.gaps[i] == tag.gap then
      next = i + 1
      break
    end
  end
  if #beautiful.gaps < next then
    next = 1
  end
  tag.gap = beautiful.gaps[next]
  awful.layout.arrange(awful.screen.focused())
end
