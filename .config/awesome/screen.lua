screens = {}
screens.list = {}

awful.screen.connect_for_each_screen(
  function(s)
    screens.list = gears.table.join(screens.list, {s})
  end
)

if #screens.list == 2 then
  screens.list = {screens.list[2], screens.list[1]}
end

screens.primary = screens.list[1]
screen.primary = screens.list[1]
