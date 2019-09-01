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

sheet\add_style(nil, "back"
  cord.wim.style({
    background_color: cord.util.pattern({{cord.util.color("#ff0000")}, {cord.util.color("#ff2020")}}),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#000000"),
    size: cord.math.vector(300, 300),
    padding: cord.util.margin(10),
    margin: cord.util.margin(5),
    layout: cord.wim.layouts.fit.horizontal(),
    pattern_beginning: cord.math.vector(0, 0, "percentage"),
    pattern_ending: cord.math.vector(1, 1, "percentage")
  })
)

sheet\add_style(nil, "front",
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#FFFFFF")
    size: cord.math.vector(0.35, 0.6, "percentage"),
    padding: cord.util.margin(5),
    pos: cord.math.vector(0),
    layout_appear_animation: cord.wim.animations.position.lerp_from_edge,
    layout_move_animation: cord.wim.animations.position.lerp,
    position_animation_speed: 0.2
  })
)

sheet\add_style(nil, "front2",
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#FFFFFF"),
    size: cord.math.vector(0.65, 0.4, "percentage"),
    padding: cord.util.margin(5),
    layout_appear_animation: cord.wim.animations.position.lerp_from_edge,
    layout_move_animation: cord.wim.animations.position.lerp,
    position_animation_speed: 0.2
  })
)

sheet\add_style(nil, "front3",
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#FFFFFF"),
    size: cord.math.vector(1, 0.1, "percentage"),
    padding: cord.util.margin(5),
    layout_appear_animation: cord.wim.animations.position.lerp_from_edge,
    layout_move_animation: cord.wim.animations.position.lerp,
    position_animation_speed: 0.2
  })
)

node_front = cord.wim.node(nil, "front", sheet, {}, {visible: false})
node_front2 = cord.wim.node(nil, "front2", sheet, {}, {visible: false})
node_front3 = cord.wim.node(nil, "front3", sheet, {}, {visible: false})
node_back = cord.wim.node(nil, "back", sheet, {node_front, node_front2, node_front3})

node_back\set_visible(true)

gears.timer({
  autostart: true,
  single_shot: true,
  timeout: 0.5,
  callback: () ->
    node_front3\set_visible(true)
})

gears.timer({
  autostart: true,
  single_shot: true,
  timeout: 1,
  callback: () ->
    node_front2\set_visible(true)
})

gears.timer({
  autostart: true,
  single_shot: true,
  timeout: 1.5,
  callback: () ->
    node_front\set_visible(true)
})

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
