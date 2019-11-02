wibox = require "wibox"
gears = require "gears"
awful = require "awful"
beautiful = require "beautiful"

cord = require "cord"
  
sheet = cord.wim.stylesheet()

sheet\add_style("box", nil, cord.wim.style({
  padding: cord.util.margin(10)
  shape: cord.util.shape.rectangle(10)
  layout: cord.wim.layouts.fit.horizontal!
  layout_show_animation: cord.wim.animations.position.lerp_from_edge
  layout_move_animation: cord.wim.animations.position.lerp
  layout_hide_animation: cord.wim.animations.position.lerp_to_edge
  opacity_show_animation: cord.wim.animations.opacity.lerp
  opacity_hide_animation: cord.wim.animations.opacity.lerp
  position_animation_speed: 0.3
  opacity_animation_speed: 0.3
}))

sheet\add_style(nil, "back", cord.wim.style({
  background: "#404040"
  size: cord.math.vector(400, 200)
}), {{"box"}})

sheet\add_style(nil, "front", cord.wim.style({
  background: "#cc9393"
  size: cord.math.vector(0.5, 1, "percentage")
}), {{"box"}})

sheet\add_style("text", nil, cord.wim.style({
  font: "Mono 30"
  color: "#FFFFFF"
  halign: "center"
  valign: "center"
  size: cord.math.vector(1, 1, "percentage")
}))

text = cord.wim.text("text", nil, sheet, "r/unixporn")
front = cord.wim.node("box", "front", sheet)
back = cord.wim.node("box", "back", sheet, {text})

widget = wibox.widget({
  layout: wibox.layout.manual
  back.widget
})

back\set_visible(true, true)
back\set_opacity(1)
text\set_visible(true)
front\set_visible(true)

box = wibox({
  bg: "#212121"
  visible: true
  widget: widget
  width: 400
  height: 400
})
