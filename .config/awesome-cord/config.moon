wibox = require "wibox"
gears = require "gears"
awful = require "awful"
beautiful = require "beautiful"

cord = require "cord"

screens = {}
  
awful.screen.connect_for_each_screen((s) ->
  table.insert(screens, s)
)

sheet = cord.wim.stylesheet()

sheet\add_style(nil, "test_label"
  cord.wim.style({
    background_color: cord.util.color("#FFFFFF"),
    size: cord.math.vector(200, 200),
    padding: cord.util.margin(20)
  })
)
  
node = cord.wim.node(nil, "test_label", sheet, {wibox.widget.textbox("TESTING")})

widget = wibox.widget({
  layout: wibox.layout.manual,
  node.widget
})
  
box = wibox({
  x: screens[1].geometry.x,
  y: screens[1].geometry.y,
  width: screens[1].geometry.width,
  height: screens[1].geometry.height,
  ontop: true,
  visible: true,
  widget: widget,
  bg: "#212121"
})

return {}
