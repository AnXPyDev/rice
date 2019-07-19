colorful = {}
colorful.tintCount = 25
colorful.background = "#121212"
colorful.foreground = "#FFFFFF"
colorful.primary = "#eb3434"
colorful.complementary = "#69e0cf"
colorful.onBackground = colorful.foreground
colorful.onForeground = colorful.background
colorful.onPrimary = colorful.background
colorful.onComplementary = colorful.background

-- Create all colors other colors

colorful.primaryTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.primary):tints(colorful.tintCount))
colorful.primaryShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.primary):shades(colorful.tintCount))
colorful.complementaryTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.complementary):tints(colorful.tintCount))
colorful.complementaryShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.complementary):shades(colorful.tintCount))
colorful.backgroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.background):shades(colorful.tintCount))
colorful.backgroundTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.background):tints(colorful.tintCount))
colorful.foregroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.foreground):shades(colorful.tintCount))
colorful.foregroundTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.foreground):tints(colorful.tintCount))
colorful.onBackgroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onBackground):shades(colorful.tintCount))
colorful.onBackgroundTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onBackground):tints(colorful.tintCount))
colorful.onForegroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onForeground):shades(colorful.tintCount))
colorful.onForegroundTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onForeground):tints(colorful.tintCount))
colorful.onPrimaryShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onPrimary):shades(colorful.tintCount))
colorful.onPrimaryTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onPrimary):tints(colorful.tintCount))
colorful.onComplementaryShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onComplementary):shades(colorful.tintCount))
colorful.onComplementaryTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onComplementary):tints(colorful.tintCount))

themeful = {}
themeful.radius = dpi(3)
themeful.shape = function(cr, w, h) return gears.shape.rounded_rect(cr, w, h, themeful.radius) end
themeful.font = "Roboto Italic " .. tostring(dpi(12))
themeful.fontMono = "Hack " .. tostring(dpi(12))
themeful.gap = dpi(0)
themeful.gaps = {dpi(0), dpi(8), dpi(12), dpi(32)}
themeful.barSize = dpi(30)
themeful.margins = margins(dpi(5))
themeful.outsideMargins = margins(dpi(10))


-- Search Menu

themeful.searchMenu = {}

themeful.searchMenu.prompt = {
	bg = colorful.backgroundTints[1],
	fg = colorful.onBackground,
	shape = themeful.shape,
	text = "",
	font = themeful.fontMono,
	margins = margins(dpi(15), nil, dpi(5)),
	outsideMargins = margins(0),
	halign = "left",
	valign = "center"
}

themeful.searchMenu.elements = {
	bg = colorful.background,
	fg = colorful.onBackground,
	bgHl = colorful.primary,
	fgHl = colorful.onPrimary,
	halign = "center",
	valign = "center",
	font = themeful.font,
	margins = themeful.margins,
	outsideMargins = themeful.outsideMargins,
	showcaseMargins = margins(dpi(5)),
	shape = themeful.shape
}

themeful.searchMenu.wibox = {
	bg = colorful.background,
	fg = colorful.onBackground,
	size = {dpi(800), dpi(600)},
	shape = themeful.shape
}

-- Tag Indicator

themeful.tagIndicator = {}

themeful.tagIndicator.wibox = {
	size = {nil, nil},
	pos = {nil, nil},
	bg = colorful.background,
	fg = colorful.onBackground,
	shape = themeful.shape
}

themeful.tagIndicator.tags = {
	size = {dpi(40), dpi(40)},
	margins = themeful.outsideMargins,
	colors = {
		focused = colorful.primary,
		occupied = colorful.complementary,
		normal = colorful.backgroundTints[1]
	},
	shape = themeful.shape
}

-- Slider

themeful.slider = {}

themeful.slider.wibox = {
  pos = {0,0},
  size = {dpi(100), dpi(300)},
  bg = colorful.background,
  shape = themeful.shape
}

themeful.slider.sliders = {
  sliderArgs = {
    bar_shape = gears.shape.rounded_bar,
    handle_shape = themeful.shape,
    bar_color = colorful.onBackground,
    handle_color = colorful.primary,
    bar_height = dpi(5)
  },
  direction = "horizontal",
  sliderMargins = themeful.outsideMargins,
  sliderBg = colorful.background,
  sliderShape = themeful.shape,
  sliderOutsideMargins = margins(0),
  showcasePosition = "left",
  showcaseMargins = margins(dpi(10)),
  showcaseBg = colorful.primary,
  showcaseShape = themeful.shape,
  showcaseOutsideMargins = margins(dpi(5)),
  sliderSize = {},
  showcaseSize = {},
  size = {},
  margins = themeful.outsideMargins,
  bg = colorful.background,
  shape = themeful.shape,
  outsideMargins = margins(0)
}

themeful.statusBar = {}

themeful.statusBar.wibox = {
  fg = colorful.onBackground,
  bg = colorful.background,
	shape = themeful.shape,
	margins = themeful.outsideMargins
}

themeful.statusBar.widgets = {
  bg = colorful.backgroundTints[2],
	fg = colorful.onBackground,
	shape = themeful.shape
}

themeful.showcase = {
	bg = colorful.backgroundTints[2],
	fg = colorful.onBackground,
	margins = margins(dpi(10)),
	outsideMargins = margins(dpi(10)),
	showcaseMargins = margins(dpi(10)),
	showcasePosition = "left",
	shape = themeful.shape
}

local theme = {}

gears.shape.fixed_rounded_rect = gears.shape.rectangle

-- Colors

theme.bg_normal = colorful.background
theme.fg_normal = colorful.foregroundShades[4]
theme.bg_focus = colorful.backgroundTints[2]
theme.fg_focus = colorful.foreground
theme.font = themeful.font
theme.font_name = "Hack"
theme.font_size = 12

-- Other

theme.useless_gap = themeful.gap
theme.titlebar_size = themeful.barSize
theme.corner_radius = themeful.radius



theme.showcase = {
	bg = colorful.backgroundTints[2],
	fg = colorful.onBackground,
	margins = margins(dpi(10)),
	outsideMargins = margins(dpi(10)),
	showcaseMargins = margins(dpi(10)),
	showcasePosition = "left",
	shape = themeful.shape
}

theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus

beautiful.init(theme)
