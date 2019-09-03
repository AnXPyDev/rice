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

sheet\add_style("box", nil, cord.wim.style({
  shape: cord.util.shape.rectangle(5),
  padding: cord.util.margin(5),
  margin: cord.util.margin(5),
  layout: cord.wim.layouts.fit.horizontal(),
  size: cord.math.vector(0.5, 0,5, "percentage"),
  layout_show_animation: cord.wim.animations.position.lerp_from_edge,
  layout_move_animation: cord.wim.animations.position.lerp,
  position_animation_speed: 0.2
}))

sheet\add_style(nil, "back", cord.wim.style({
  background_color: cord.util.pattern({{"#ff2313"}, {"#fe3213"}})
  size: cord.math.vector(400)
  padding: cord.util.margin(10)
}), {{"box"}})

sheet\add_style("front", nil, cord.wim.style({
  background_color: cord.util.color("#000000")
  size: cord.math.vector(0.5, nil, "percentage")
}), {{"box"}})

sheet\add_style("frontest", nil, cord.wim.style({
  background_color: cord.util.color("#FFFFFF")
  size: cord.math.vector(0.5, nil, "percentage")
}), {{"box"}})

frontest = {}
front = {}

for i = 1,4
  tbl = {}
  -- for e = 1,4
  --   table.insert(tbl, cord.wim.node("frontest", "frontest_#{i}_#{e}", sheet, {}, {visible: false}))
  table.insert(frontest, tbl)
  table.insert(front, cord.wim.node("front", "front_#{i}", sheet, frontest[i], {visible: false}))


for i = 1, #front
  gears.timer({
    autostart: true,
    single_shot: true,
    timeout: i * 0.5,
    callback: () ->
      front[i]\set_visible(true)
  })
  children = front[i].children
  for e = 1, #children
    gears.timer({
      autostart: true,
      single_shot: true,
      timeout: e * 0.2 + i * 0.5,
      callback: () ->
        children[e]\set_visible(true)
    })

back = cord.wim.node(nil, "back", sheet, front)  
  
widget = wibox.widget({
  layout: wibox.layout.manual,
  back.widget
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
