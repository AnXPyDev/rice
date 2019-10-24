local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local cord = require("cord")
print(cord.util.margin(5).left)
local screens = { }
awful.screen.connect_for_each_screen(function(s)
  return table.insert(screens, s)
end)
local sheet = cord.wim.stylesheet()
sheet:add_style("box", nil, cord.wim.style({
  shape = cord.util.shape.rectangle(5),
  padding = cord.util.margin(5),
  margin = cord.util.margin(5),
  layout = cord.wim.layouts.fit.horizontal(),
  size = cord.math.vector(1, 0, 5, "percentage"),
  layout_show_animation = cord.wim.animations.position.lerp_from_edge,
  layout_hide_animation = cord.wim.animations.position.lerp_to_edge,
  layout_move_animation = cord.wim.animations.position.lerp,
  opacity_show_animation = cord.wim.animations.opacity.lerp,
  opacity_hide_animation = cord.wim.animations.opacity.lerp,
  color_lerp_animation_speed = 0.05,
  opacity_lerp_animation_speed = 0.3,
  position_lerp_animation_speed = 0.3
}))
sheet:add_style(nil, "back", cord.wim.style({
  background_color = cord.util.pattern({
    {
      "#ff2313"
    },
    {
      "#fe3213"
    }
  }),
  size = cord.math.vector(400),
  padding = cord.util.margin(10),
  margin = cord.util.margin(20)
}), {
  {
    "box"
  }
})
sheet:add_style("front", nil, cord.wim.style({
  background_color = cord.util.color("#000000"),
  size = cord.math.vector(0.5, nil, "percentage"),
  margin = cord.util.margin(10)
}), {
  {
    "box"
  }
})
sheet:add_style("frontest", nil, cord.wim.style({
  background_color = cord.util.color("#FFFFFF"),
  size = cord.math.vector(0.5, nil, "percentage")
}), {
  {
    "box"
  }
})
sheet:add_style("text", nil, cord.wim.style({
  color = "#ffffff",
  size = cord.math.vector(1, 1, "percentage"),
  align_horizontal = "center",
  align_vertical = "center",
  font = "Hack 20"
}))
sheet:add_style("image", nil, cord.wim.style({
  size = cord.math.vector(1, 1, "percentage"),
  color = cord.util.color("#ffffff")
}))
local frontest = { }
local front = { }
for i = 1, 4 do
  local tbl = {
    cord.wim.image("image", "image_" .. tostring(i), sheet, cord.util.image("/home/bob/.icons/awesomewm.png"))
  }
  table.insert(frontest, tbl)
  table.insert(front, cord.wim.node("front", "front_" .. tostring(i), sheet, frontest[i], {
    visible = false
  }))
  front[i]:connect_signal("mouse_enter", function()
    return print("mouse enter " .. tostring(i))
  end)
  front[i]:connect_signal("mouse_leave", function()
    return print("mouse leave " .. tostring(i))
  end)
end
for i = 1, #front do
  gears.timer({
    autostart = true,
    single_shot = true,
    timeout = i * 0.5,
    callback = function()
      return front[i]:set_visible(true)
    end
  })
  gears.timer({
    autostart = true,
    single_shot = true,
    timeout = ((#front + 1) - i) * 0.5 + 5,
    callback = function()
      return front[i]:set_visible(false)
    end
  })
end
local back = cord.wim.node(nil, "back", sheet, front)
cord.wim.animations.color.lerp(back, "#000000", "#FFFFFF", "background")
local widget = wibox.widget({
  layout = wibox.layout.manual,
  back.widget
})
local box = wibox({
  x = screens[1].geometry.x,
  y = screens[1].geometry.y,
  width = screens[1].geometry.width,
  height = screens[1].geometry.height,
  ontop = true,
  visible = true,
  widget = widget,
  bg = "#212121"
})
return { }
