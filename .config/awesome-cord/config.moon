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

test_layout = wibox.layout.manual
  
sheet\add_style(nil, "back"
  cord.wim.style({
    background_color: cord.util.pattern({{cord.util.color("#ffffff")}, {cord.util.color("#212121")}}),
    color: cord.util.color("#000000"),
    size: cord.math.vector(300, 300),
    padding: cord.util.margin(10),
    margin: cord.util.margin(10),
    layout: cord.wim.layout.fit,
    pattern_beginning: cord.math.vector(0, 0, "percentage"),
    pattern_ending: cord.math.vector(0, 1, "percentage")
  })
)

sheet\add_style(nil, "front"
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    color: cord.util.color("#FFFFFF")
    size: cord.math.vector(0.5, 0.5, "percentage"),
    padding:cord.util.margin(5)
  })
)

sheet\add_style(nil, "front2"
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    color: cord.util.color("#FFFFFF")
    size: cord.math.vector(0.4, 0.4, "percentage"),
    padding:cord.util.margin(5),
  })
)

  
node_front = cord.wim.node(nil, "front", sheet, {})
node_front2 = cord.wim.node(nil, "front2", sheet, {})
node_back = cord.wim.node(nil, "back", sheet, {node_front, node_front2})

widget = wibox.widget({
  layout: wibox.layout.manual,
  node_back.widget
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
