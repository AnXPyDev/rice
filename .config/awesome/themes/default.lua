local theme = {
  useless_gap = dpi(8),
  gaps = {dpi(8), dpi(24), dpi(40), 0},
  corner_radius = dpi(5),
  bg_normal = "#202020",
  bg_focus = "#fe4848",
  fg_normal = "#909090",
  fg_focus = "#FFFFFF",
  titlebar_size = dpi(25),
  font_name = "Hack",
  font_size = dpi(10),
  wibar_height = dpi(30),
  wibar_bg = "#101010",
  border_width = 0
}

gears.shape.fixed_rounded_rect = function(cr, w, h)
  return gears.shape.rounded_rect(cr, w, h, theme.corner_radius)
end

theme = gears.table.join(theme, {
  notification_border_width = 0,
  notification_border_color = "#202020",
  notification_shape = gears.shape.fixed_rounded_rect,
  notification_font = "Hack 12",
  notification_margin = dpi(20)
})

theme.searchMenu = {}

theme.searchMenu.prompt = {
  bg = "#202020",
  fg = "#FFFFFF",
  halign = "center",
  valign = "center",
  text = "",
  font = "Hack 12",
  shape = gears.shape.fixed_rounded_rect,
  margins = {
    left = dpi(5),
    right = dpi(5),
    top = dpi(5),
    bottom = dpi(5)
  },
  outsideMargins = {
    left = dpi(10),
    right = dpi(10),
    top = dpi(10),
    bottom = dpi(10)
  }
}

theme.searchMenu.elements = {
  bg = "#101010",
  fg = "#FFFFFF",
  bgHl = theme.bg_focus,
  fgHl = "#000000",
  halign = "left",
  valign = "center",
  font = "Hack 10",
  shape = gears.shape.fixed_rounded_rect,
  margins = {
    left = dpi(5),
    right = dpi(5),
    top = dpi(5),
    bottom = dpi(5)
  },
  outsideMargins = {
    left = dpi(10),
    right = dpi(10),
    top = dpi(5),
    bottom = dpi(5)
  }
}

theme.searchMenu.wibox = {
  bg = "#101010",
  fg = "#FFFFFF",
  size = {dpi(800), dpi(600)},
  shape = function(cr, w, h)
    return gears.shape.partially_rounded_rect(cr, w, h, false, false, false, false, theme.corner_radius)
  end
}

theme.tagIndicator = {}

theme.tagIndicator.wibox = {
  size = {nil, nil},
  pos = {nil, nil},
  bg = "#101010",
  shape = function(cr, w, h)
    return gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, theme.corner_radius)
  end
}


theme.tagIndicator.tags = {
  size = {dpi(40), dpi(40)},
  margins = {
    left = dpi(10),
    right = dpi(10),
    top = dpi(10),
    bottom = dpi(10)
  },
  colors = {
    focused = theme.bg_focus,
    occupied = "#606060",
    normal = "#202020"
  },
  shape = gears.shape.fixed_rounded_rect
}

theme.slider = {}

theme.slider.wibox = {
  pos = {0,0},
  size = {dpi(100), dpi(300)},
  bg = "#101010",
  shape = gears.shape.fixed_rounded_rect
}

theme.slider.sliders = {
  sliderArgs = {
    bar_shape = gears.shape.rounded_bar,
    handle_shape = gears.shape.circle,
    bar_color = "#808080",
    handle_color = "#FFFFFF",
    bar_height = dpi(4)
  },
  direction = "vertical",
  sliderMargins = margins(dpi(20)),
  sliderBg = "#303030",
  sliderShape = gears.shape.fixed_rounded_rect,
  sliderOutsideMargins = margins(dpi(5)),
  showcasePosition = "bottom",
  showcaseMargins = margins(dpi(10)),
  showcaseBg = theme.bg_focus,
  showcaseShape = gears.shape.fixed_rounded_rect,
  showcaseOutsideMargins = margins(dpi(5)),
  sliderSize = {},
  showcaseSize = {},
  size = {},
  margins = margins(dpi(10)),
  bg = "#202020",
  shape = gears.shape.fixed_rounded_rect,
  outsideMargins = margins(dpi(10))
}

theme.statusBar = {}

theme.statusBar.wibox = {
  fg = "#FFFFFF",
  bg = "#101010"
}

theme.statusBar.widgets = {
  bg = "#202020"
}

theme.font = theme.font_name .. " " .. tostring(theme.font_size)
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus

beautiful.init(theme)
