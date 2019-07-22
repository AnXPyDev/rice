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
	shape = themeful.shape,
	text = "",
	font = themeful.fontMono,
	margins = margins(dpi(15), nil, dpi(5)),
	outsideMargins = margins(0),
	halign = "left",
	valign = "center"
}

themeful.searchMenu.elements = {
	halign = "center",
	valign = "center",
	font = themeful.font,
	margins = themeful.margins,
	outsideMargins = themeful.outsideMargins,
	showcaseMargins = margins(dpi(5)),
	shape = themeful.shape
}

themeful.searchMenu.wibox = {
	size = {dpi(800), dpi(600)},
	shape = themeful.shape
}

-- Slider

themeful.slider = {}

themeful.slider.wibox = {
  pos = {0,0},
  size = {dpi(100), dpi(300)},
  shape = themeful.shape
}

themeful.slider.sliders = {
  sliderArgs = {},
  direction = "horizontal",
  sliderMargins = themeful.outsideMargins,
  sliderShape = themeful.shape,
  sliderOutsideMargins = margins(0),
  showcasePosition = "left",
  showcaseMargins = margins(dpi(10)),
  showcaseShape = themeful.shape,
  showcaseOutsideMargins = margins(dpi(5)),
  sliderSize = {},
  showcaseSize = {},
  size = {},
  margins = themeful.outsideMargins,
  shape = themeful.shape,
  outsideMargins = margins(0)
}

themeful.statusBar = {}

themeful.statusBar.wibox = {
	shape = themeful.shape,
	margins = themeful.outsideMargins
}

themeful.statusBar.widgets = {
	shape = themeful.shape
}

themeful.showcase = {
	margins = margins(dpi(10)),
	outsideMargins = margins(dpi(10)),
	showcaseMargins = margins(dpi(10)),
	showcasePosition = "left",
	shape = themeful.shape
}

themeful.internetIndicator = {
	shape = themeful.shape,
	animate = true
}

themeful.batteryIndicator = {
	shape = themeful.shape,
	barShape = themeful.shape,
	animate = true
}

themeful.loadScreen = {
	imageShape = themeful.shape,
	imagePath = PATH.icons .. "awesomewm.png"
}

themeful.titleButton = {
	margins = margins(dpi(8))
}

themeful.timeIndicator = {
	margins = themeful.outsideMargins,
	shape = themeful.shape
}

themeful.tagIndicator = {
	shape = themeful.shape,
	tagShape = themeful.shape,
	margins = themeful.outsideMargins,
	animate = true,
	tagSize = {dpi(40), dpi(40)}
}

themeful.volumeControl = {
	animate = true
}

themeful.keyboardIndicator = {
	animate = true
}

theme.useless_gap = themeful.gap
theme.titlebar_size = themeful.barSize
theme.corner_radius = themeful.radius
theme.font = themeful.font
theme.font_name = "Hack"
theme.font_size = 12
