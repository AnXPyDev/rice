local theme = {
  useless_gap = dpi(8),
  gaps = {dpi(8), dpi(24), dpi(40), 0},
  corner_radius = dpi(5),
  bg_normal = "#FFFFFF",
  bg_focus = "#FFFFFF",
  fg_normal = "#909090",
  fg_focus = "#000000",
  titlebar_size = dpi(25),
  font_name = "Hack",
  font_size = dpi(8),
  tagIndicator_bg = "#303030",
  tagIndicator_focused = "#FFFFFF",
  tagIndicator_occupied = "#CCCCCC",
  tagIndicator_normal = "#808080",
  searchMenu_bg = "#303030",
  searchMenu_fg = "#FFFFFF",
  searchMenu_promptBg = "#404040",
  searchMenu_elementHighlight = "#FFFFFF",
  searchMenu_elementHighlightFg = "#000000"
}

theme.searchMenu = {}

theme.searchMenu.prompt = {
  bg = "#202020",
  fg = "#FFFFFF",
  halign = "center",
  valign = "center",
  text = "",
  font = "Hack 12",
  shape = function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, theme.corner_radius)
  end,
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
    bottom = dpi(5)
  }
}

theme.searchMenu.elements = {
  bg = "#404040",
  fg = "#FFFFFF",
  bgHl = "#FFFFFF",
  fgHl = "#000000",
  halign = "left",
  valign = "center",
  font = "Hack 10",
  shape = function(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, theme.corner_radius)
  end,
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
  bg = "#202020",
  fg = "#FFFFFF",
  size = {dpi(800), dpi(600)},
  shape = function(cr, w, h)
    return gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, theme.corner_radius)
  end
}


theme.font = theme.font_name .. " " .. tostring(theme.font_size)
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus
theme.searchMenu_promptFont_size = 10
theme.searchMenu_promptFont = theme.font_name .. " " .. tostring(dpi(theme.searchMenu_promptFont_size))
theme.searchMenu_elementFont = theme.searchMenu_promptFont

beautiful.init(theme)
