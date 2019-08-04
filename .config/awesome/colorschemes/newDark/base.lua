colorful = genColorScheme(
  "#121212",
  "#FFFFFF",
  {
    red = "#FF0000",
    green = "#00FF00",
    blue = "#0000FF",
    primary = "#FF0000",
    complementary = "#00FF00"
  },
  10
)

gears.table.crush(themeful.titleBar, {
	bgFocus = colorful.background.alternates[3],
	fgFocus = colorful.background.on.base,
	bg = colorful.background.base,
	fg = colorful.background.on.base
})

gears.table.crush(themeful.searchMenu.prompt, {
	bg = colorful.background.alternates[1],
	fg = colorful.background.on.base,
})

gears.table.crush(themeful.searchMenu.elements, {
	bg = colorful.background.base,
	fg = colorful.background.on.base,
	bgHl = colorful.primary.base,
	fgHl = colorful.primary.on.base
})

gears.table.crush(themeful.searchMenu.wibox, {
	bg = colorful.background.base,
	fg = colorful.background.on.base
})

gears.table.crush(themeful.slider.wibox, {
	bg = colorful.background.base
})

gears.table.crush(themeful.slider.sliders, {
  sliderArgs = {
    bar_shape = gears.shape.rounded_bar,
    handle_shape = themeful.shape,
    bar_color = colorful.background.alternates[4],
    handle_color = colorful.primary.base,
    bar_height = dpi(5)
  },
  sliderBg = colorful.background.base,
  showcaseBg = colorful.primary.base,
  bg = colorful.background.base
})

gears.table.crush(themeful.statusBar.wibox, {
	fg = colorful.background.on.base,
  bg = colorful.background.base
})

gears.table.crush(themeful.statusBar.widgets, {
  bg = colorful.background.alternates[2],
	fg = colorful.background.on.base
})

gears.table.crush(themeful.showcase, {
	bg = colorful.background.alternates[2],
	fg = colorful.background.on.base
})

gears.table.crush(themeful.internetIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg,
	bgOnline = colorful.primary.base,
	fgOnline = colorful.primary.on.base,
	bg2Online = colorful.primary.alternates[5]
})

gears.table.crush(themeful.batteryIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg,
	bgHl = colorful.primary.base,
	bg2Hl = colorful.primary.alternates[5]
})

gears.table.crush(themeful.loadScreen, {
	startBg = "#000000",
	targetBg = colorful.background.base,
	imageColor = colorful.primary.base,
	imageBg = colorful.background.alternates[2]
})

gears.table.crush(themeful.button, {
	bg = colorful.background.alternates[2],
	fg = colorful.background.on.base,
	bgHover = colorful.complementary.base,
	fgHover = colorful.complementary.on.base,
	bgClick = colorful.complementary.alternates[3],
	fgClick = colorful.complementary.on.base,
})

gears.table.crush(themeful.timeIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg
})

gears.table.crush(themeful.tagIndicator, {
	bg = colorful.background.base,
	fg = colorful.background.on.base,
	clrNormal = colorful.background.alternates[4],
	clrFocused = colorful.primary.base,
	clrOccupied = colorful.complementary.base
})

gears.table.crush(themeful.keyboardIndicator, {
	bg = colorful.complementary.base,
	fg = colorful.complementary.on.base,
	blinkBg = colorful.complementary.alternates[3]
})

gears.table.crush(themeful.statusButtons, {
	bgHover = colorful.primary.base,
	fgHover = colorful.primary.on.base,
	bgClick = colorful.primary.alternates[3],
	fgClick = colorful.primary.on.base
})

gears.table.crush(themeful.titleButtons, {
  tileBgHover = colorful.primary.base,
  tileFgHover = colorful.primary.on.base,
  tileBgClick = colorful.primary.alternates[3],
  closeBgHover = colorful.complementary.base,
  closeFgHover = colorful.complementary.on.base,
  closeBgClick = colorful.complementary.alternates[3]
})

theme.bg_normal = colorful.background.base
theme.fg_normal = colorful.foreground.alternates[4]
theme.bg_focus = colorful.background.alternates[2]
theme.fg_focus = colorful.foreground.base
