screens = {}
screens.list = {}

awful.screen.connect_for_each_screen(
  function(s)
    screens.list = gears.table.join(screens.list, {s})
  end
)

for i = 1, #screens.list do
  set_wallpaper(screens.list[i])
end

screens.primary = screens.list[1]
