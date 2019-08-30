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

animator = cord.wim.animator(60)

class position_animation extends cord.wim.animation
  new: (node, start, target) =>
    super!
    @node = node
    if @node.position_animation
      @node.position_animation.done = true
    @node.position_animation = self
    @current = start\copy!
    @target = target
    @node\set_pos(@current)
    animator\add(self)
  tick: =>
    @current.x = cord.math.lerp(@current.x, @target.x, 0.2, 0.1)
    @current.y = cord.math.lerp(@current.y, @target.y, 0.2, 0.1)
    @node\set_pos(@current)
    if @current.x == @target.x and @current.y == @target.y
      @done = true
      return true
    return false

class expand_animation extends cord.wim.animation
  new: (node, target) =>
    super!
    @node = node
    if @node.expand_animation
      @node.expand_animation.done = true
    @current = @node.expand_animation.current or @node.style\get("padding")\copy!
    @node.expand_animation = self
    @target = cord.util.margin(0)
    @node\set_pos(@current)
    animator\add(self)
  tick: =>
    @current.left = cord.math.lerp(@current.left, @target.left, 0.2, 0.1)
    @current.right = cord.math.lerp(@current.right, @target.right, 0.2, 0.1)
    @current.top = cord.math.lerp(@current.top, @target.top, 0.2, 0.1)
    @current.bottom = cord.math.lerp(@current.bottom, @target.bottom, 0.2, 0.1)
    @current\apply(@node.containers.padding)
    if @current.left == @target.left and
      @current.top == @target.top and
      @current.bottom == @target.bottom and
      @current.right == @target.right then
      @done = true
      return true
    return false

sheet\add_style(nil, "back"
  cord.wim.style({
    background_color: cord.util.pattern({{cord.util.color("#ff2123")}, {cord.util.color("#ff4445")}}),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#000000"),
    size: cord.math.vector(300, 300),
    padding: cord.util.margin(10),
    margin: cord.util.margin(5),
    layout: cord.wim.layouts.fit.vertical(),
    pattern_beginning: cord.math.vector(0, 0, "percentage"),
    pattern_ending: cord.math.vector(1, 1, "percentage")
  })
)

sheet\add_style(nil, "front"
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#FFFFFF")
    size: cord.math.vector(1, cord.math.value(40, 0, "pixel"), "percentage"),
    padding: cord.util.margin(5),
    pos: cord.math.vector(0),
    layout_appear_animation: position_animation,
    layout_move_animation: position_animation
  })
)

sheet\add_style(nil, "front2"
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#FFFFFF")
    size: cord.math.vector(0.75, 0.5, "percentage"),
    padding: cord.util.margin(5),
    layout_appear_animation: position_animation,
    layout_move_animation: position_animation
  })
)

sheet\add_style(nil, "front3"
  cord.wim.style({
    background_color: cord.util.color("#000000"),
    background_shape: cord.util.shape.rectangle(3),
    color: cord.util.color("#FFFFFF")
    size: cord.math.vector(0.25, 0.25, "percentage"),
    padding: cord.util.margin(5),
    layout_appear_animation: position_animation,
    layout_move_animation: position_animation
  })
)

node_front = cord.wim.node(nil, "front", sheet, {})
node_front2 = cord.wim.node(nil, "front2", sheet, {})
node_front3 = cord.wim.node(nil, "front3", sheet, {})
node_back = cord.wim.node(nil, "back", sheet, {node_front, node_front2, node_front3})

node_front\connect_signal("mouse_enter", () -> print("mouse_enter node_front"))
  
node_back\set_visible(true)

gears.timer({
  single_shot: true,
  autostart: true,
  timeout: 0.25,
  callback: () ->
    node_front2\set_visible(true)
})

gears.timer({
  single_shot: true,
  autostart: true,
  timeout: 0.5,
  callback: () ->
    node_front3\set_visible(true)
})

gears.timer({
  single_shot: true,
  autostart: true,
  timeout: 0.75,
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
