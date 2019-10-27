wibox = require "wibox"
gears = require "gears"
awful = require "awful"
beautiful = require "beautiful"

cord = require "cord"

print(cord.util.margin(5).left)
  
screens = {}
  
sheet = cord.wim.stylesheet()

sheet\add_style("box", nil, cord.wim.style({
  shape: cord.util.shape.rectangle(10),
  padding: cord.util.margin(5),
  margin: cord.util.margin(5),
  layout: cord.wim.layouts.fit.horizontal(),
  size: cord.math.vector(1, 0,5, "percentage"),
  layout_show_animation: cord.wim.animations.position.lerp_from_edge,
  layout_hide_animation: cord.wim.animations.position.lerp_to_edge,
  layout_move_animation: cord.wim.animations.position.lerp,
  opacity_show_animation: cord.wim.animations.opacity.lerp,
  opacity_hide_animation: cord.wim.animations.opacity.lerp,
  color_lerp_animation_speed: 0.05,
  opacity_lerp_animation_speed: 0.3,
  position_lerp_animation_speed: 0.3
}))

sheet\add_style(nil, "back", cord.wim.style({
  background_color: cord.util.pattern({{"#cc5050", 0}, {"#cc8080", 1}}, cord.math.vector(0, nil, "percentage"), cord.math.vector(1, 0, "percentage"))
  size: cord.math.vector(400)
  padding: cord.util.margin(10)
  margin: cord.util.margin(20)
  
}), {{"box"}})

sheet\add_style(nil, "back1", cord.wim.style({
  background_color: cord.util.pattern({{"#50cc50", 0}, {"#80cc80", 1}}, cord.math.vector(0, 0, "percentage"), cord.math.vector(0, 1, "percentage"))
  size: cord.math.vector(200)
  padding: cord.util.margin(10)
  margin: cord.util.margin(20)
  
}), {{"box"}})

sheet\add_style("front", nil, cord.wim.style({
  background_color: cord.util.pattern({{"#ffffff"}, {"#cccccc"}})
  size: cord.math.vector(1, 0.5, "percentage")
  margin: cord.util.margin(10)
}), {{"box"}})
  

sheet\add_style("frontest", nil, cord.wim.style({
  background_color: cord.util.color("#FFFFFF")
  size: cord.math.vector(0.5, nil, "percentage")
}), {{"box"}})

sheet\add_style("text", nil, cord.wim.style({
  color: "#000000",
  size: cord.math.vector(1, 1, "percentage"),
  align_horizontal: "center",
  adaptive_colors: {{{0, 0.5}, cord.util.color("#FFFFFF")}, {{0.5, 1}, cord.util.color("#000000")}},
  align_vertical: "center",
  font: "Hack 20"
}))

sheet\add_style("image", nil, cord.wim.style({
  size: cord.math.vector(1, 1, "percentage"),
  color: cord.util.color("#ffffff")
}))

sheet\add_style("screen", nil, cord.wim.style({
  layout: cord.wim.layouts.fit.horizontal()
}))

frontest = {}
front = {}

for i = 1,2
  tbl = {
    cord.wim.text("text", "text_#{i}", sheet, "r/unixporn")
  }
  table.insert(frontest, tbl)
  table.insert(front, cord.wim.node("front", "front_#{i}", sheet, frontest[i], {visible: false}))
  front[i]\connect_signal("mouse_enter", () ->
    print("mouse enter #{i}"))
  front[i]\connect_signal("mouse_leave", () ->
    print("mouse leave #{i}"))

for i = 1, #front
  gears.timer({
    autostart: true,
    single_shot: true,
    timeout: i * 0.5,
    callback: () ->
      front[i]\set_visible(true)
  })
  gears.timer({
    autostart: true,
    single_shot: true,
    timeout: ((#front + 1) - i) * 0.5 + 5,
    callback: () ->
      front[i]\set_visible(false)
  })

back = cord.wim.nodebox(nil, "back", sheet, front)
back1 = cord.wim.nodebox(nil, "back1", sheet, {})

awful.screen.connect_for_each_screen((s) ->
  table.insert(screens, cord.wim.screen("screen", nil, sheet, s, {back, back1}))
)

back\set_visible(true, true)
back1\set_visible(true, true)

return {}
