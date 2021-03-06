themeful.radius = dpi(3)
themeful.shape = function(cr, w, h) return gears.shape.rounded_rect(cr, w, h, themeful.radius) end

themeful.fontName = "Roboto Italic"
themeful.fontSize = dpi(12)
themeful.font = themeful.fontName .. " " .. tostring(themeful.fontSize)

themeful.fontMonoName = "Hack"
themeful.fontMonoSize = dpi(12)
themeful.fontMono = themeful.fontMonoName .. " " .. tostring(themeful.fontSize)

themeful.gap = dpi(12)
themeful.gaps = {dpi(0), dpi(12), dpi(24), dpi(48), dpi(64)}
themeful.margins = margins(dpi(5))
themeful.outsideMargins = margins(dpi(10))


themeful.titleBar = {
	height = dpi(30),
	font = themeful.font
}

-- Settings for general animations

themeful.animate = {
	colorFadeAmplitude = 0.3,
	blinkUpAmplitude = 0.4,
	blinkDownAmplitude = 0.2
}

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
	shape = themeful.shape,
	animate = true
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
  sliderArgs = {
    bar_shape = gears.shape.rounded_bar,
    handle_shape = themeful.shape,
    bar_height = dpi(5)
  },
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
	shape = gears.shape.rectangle,
	outsideMargins = themeful.outsideMargins,
	margins = margins(dpi(10)),
	offset = dpi(10),
	size = {dpi(300), screens.primary.geometry.height - 2*dpi(10)}
}

themeful.statusBar.widgets = {
	shape = themeful.shape,
	spacing = dpi(10)
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
	imagePath = PATH.icons .. "awesomewm.png",
	colorFadeAmplitude = 0.05
}

themeful.button = {
	margins = margins(dpi(8)),
	outsideMargins = margins(dpi(0)),
	shape = gears.shape.rectangle,
	animateHover = true,
	animateClick = true
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
	animate = true,
  outsideMargins = themeful.outsideMargins,
  showcaseShape = themeful.shape,
  margins = margins(0)
}

themeful.keyboardIndicator = {
	animate = true
}

themeful.statusButtons = {
	margins = margins(dpi(24))
}

themeful.titleButtons = {
  shape = gears.shape.rectangle,
  outsideMargins = margins(0),
  margins = margins(dpi(8)),
  size = tableRepeat(themeful.titleBar.height, 2)
}

themeful.sysGraph = {}

themeful.launcher = {
  promptHeight = dpi(60),
  promptOutsideMargins = margins(0),
  promptShape = themeful.shape,
  elementSize = {dpi(100), dpi(120)},
  wiboxSize = {nil, nil},
  elementCount = {5, 2},
  elementMargins = margins(dpi(10)),
  elementOutsideMargins = margins(dpi(5)),
  boundedMargins = margins(dpi(20)),
  elementShape = themeful.shape,
  elementShowcaseMargins = margins(dpi(8), nil, 0, dpi(8)),
  showcasePosition = "top",
  showcaseHalign = "center",
  halign = "center",
  wiboxShape = themeful.shape,
  boundedValign = "center",
  boundedHalign = "center",
  animate = false
}

themeful.powerMenu = {
  elementSize = {dpi(90), dpi(90)},
  elementCount = {1, 4},
  elementMargins = margins(dpi(10)),
  elementOutsideMargins = margins(0),
  boundedMargins = margins(0),
  elementShape = gears.shape.rectangle,
  elementShowcaseMargins = margins(dpi(18)),
  showcasePosition = "left",
  halign = "left",
  wiboxShape = themeful.shape,
  boundedValign = "top",
  animate = false
}
gears.table.crush(naughty.config, {
	padding = dpi(10)
})

theme.useless_gap = themeful.gap
theme.font = themeful.font

resourceful["emacs.fontName"] = themeful.fontMonoName
resourceful["st.font"] = themeful.fontMonoName .. ":pixelsize=" .. tostring(themeful.fontMonoSize) .. ":antialias=true"
