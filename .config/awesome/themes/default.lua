colorful = {}
colorful.tintCount = 5
colorful.background = "#212121"
colorful.foreground = "#FFFFFF"
colorful.primary = "#6642ad"
colorful.complementary = "#ad4242"
colorful.onBackground = colorful.foreground
colorful.onForeground = colorful.background
colorful.onPrimary = colorful.background

-- Create all colors other colors

colorful.primaryTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.primary):tints(colorful.tintCount))
colorful.complementaryTints = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.complementary):tints(colorful.tintCount))
colorful.backgroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.background):shades(colorful.tintCount))
colorful.foregroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.foreground):shades(colorful.tintCount))
colorful.onBackgroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onBackground):shades(colorful.tintCount))
colorful.onForegroundShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onForeground):shades(colorful.tintCount))
colorful.onPrimaryShades = gears.table.map(function(x) return x:to_rgb() end, colors.new(colorful.onPrimary):shades(colorful.tintCount))

themeful = {}
themeful.radius = dpi(3)
themeful.shape = function(cr, w, h) return gears.shape.rounded_rect(cr, w, h, themeful.radius) end
themeful.font = "Roboto " .. tostring(dpi(11))
themeful.fontMono = "Roboto Mono " .. tostring(dpi(11))
themeful.gap = dpi(0)
themeful.gaps = {dpi(0), dpi(8), dpi(12), dpi(32)}
themeful.barSize = dpi(30)
themeful.margins = margins(dpi(5))
themeful.outsideMargins = margins(dpi(10))


-- Search Menu

themeful.searchMenu = {}

themeful.searchMenu.prompt = {
	bg = colorful.background,
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
	bg = colorful.backgroundShades[1],
	fg = colorful.onBackground,
	bgHl = colorful.primaryTints[1],
	fgHl = colorful.onPrimary,
	halign = "center",
	valign = "center",
	font = themeful.font,
	margins = themeful.margins,
	outsideMargins = themeful.outsideMargins,
	showcaseMargins = margins(0, nil, nil, dpi(5)),
	shape = themeful.shape
}

themeful.searchMenu.wibox = {
	bg = colorful.backgroundShades[1],
	fg = colorful.foregroundShades[1],
	size = {dpi(800), dpi(600)},
	shape = themeful.shape
}

-- Tag Indicator

themeful.tagIndicator = {}

themeful.tagIndicator.wibox = {
	size = {nil, nil},
	pos = {nil, nil},
	bg = colorful.background,
	fg = colorful.foreground,
	shape = themeful.shape
}

themeful.tagIndicator.tags = {
	size = {dpi(40), dpi(40)},
	margins = themeful.outsideMargins,
	colors = {
		focused = colorful.primary,
		occupied = colorful.complementary,
		normal = colorful.backgroundShades[1]
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
  sliderShape = gears.shape.fixed_rounded_rect,
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

local theme = {}

gears.shape.fixed_rounded_rect = gears.shape.rectangle

-- Colors

theme.bg_normal = colorful.backgroundShades[1]
theme.fg_normal = colorful.foregroundShades[1]
theme.bg_focus = colorful.background
theme.fg_focus = colorful.foreground
theme.font = themeful.font
theme.font_name = "Hack"
theme.font_size = 12

-- Other

theme.useless_gap = themeful.gap
theme.titlebar_size = themeful.barSize
theme.corner_radius = themeful.radius

theme.slider = {}


theme.statusBar = {}

theme.statusBar.wibox = {
  fg = "#FFFFFF",
  bg = "#101010"
}

theme.statusBar.widgets = {
  bg = "#202020"
}

theme.showcase = {
	bg = "#202020",
	fg = "#FFFFFF",
	margins = margins(dpi(10)),
	outsideMargins = margins(dpi(10)),
	showcaseMargins = margins(dpi(10)),
	showcasePosition = "left",
	shape = gears.shape.fixed_rounded_rect
}

theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus

beautiful.init(theme)
