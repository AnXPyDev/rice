wibox = require "wibox"
gears = require "gears"
awful = require "awful"
beautiful = require "beautiful"

cord = require "cord"
  
sheet = cord.wim.stylesheet()

sheet\add_style("box", nil, cord.wim.style({
  padding: cord.util.margin(10)
  shape: cord.util.shape.rectangle(10)
  layout: cord.wim.layouts.fit.horizontal
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
  size: cord.math.vector(400, 400)
}), {{"box"}})

sheet\add_style(nil, "front", cord.wim.style({
  background: "#cc9393"
  size: cord.math.vector(1, 0.5, "percentage")
}), {{"box"}})

sheet\add_style("text", nil, cord.wim.style({
  font: "Mono 30"
  color: "#FFFFFF"
  halign: "center"
  valign: "center"
  size: cord.math.vector(1, 1, "percentage")
  layout_show_animation: cord.wim.animations.position.jump
}), {{"box"}})

sheet\add_style("image", nil, cord.wim.style({
  halign: "center"
  valign: "center"
  size: cord.math.vector(1, 1, "percentage")
}), {{"box"}})

text = cord.wim.text("text", nil, sheet, "r/unixporn")
image = cord.wim.image("image", nil, sheet, cord.util.image("/home/bob/.icons/emacs.png"))
front = cord.wim.node("box", "front", sheet, {image})
front2 = cord.wim.node("box", "front", sheet, {text})
back = cord.wim.node("box", "back", sheet, {front, front2})

widget = wibox.widget({
  layout: wibox.layout.manual
  back.widget
})

back\set_visible(true, true)
back\set_opacity(1)

front\set_visible(true)
front2\set_visible(true)
text\set_visible(true)

cord.log(text\get_size!)

box = wibox({
  bg: "#212121"
  visible: true
  widget: widget
  width: 400
  height: 400
})
