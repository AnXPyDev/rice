screens = {}
screens.list = {}

awful.screen.connect_for_each_screen(
  function(s)
    screens.list = gears.table.join(screens.list, {s})
  end
)

setWallpaper()

screens.primary = screens.list[1]
