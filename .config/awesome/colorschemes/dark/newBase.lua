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
	bgHl = colorful.lightblue.base,
	fgHl = colorful.lightblue.on.base
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
    handle_color = colorful.lightblue.base,
    bar_height = dpi(5)
  },
  sliderBg = colorful.background.base,
  showcaseBg = colorful.yellow.base,
  bg = colorful.background.base
})

gears.table.crush(themeful.volumeControl, {
  wiboxBg = colorful.background.base,
  outsideMargins = themeful.outsideMargins,
  bg = colorful.background.base,
  fg = colorful.background.on.base,
  bgHl = colorful.blue.base,
  fgHl = colorful.blue.on.base
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
	bgOnline = colorful.lightblue.base,
	fgOnline = colorful.lightblue.on.base,
	bg2Online = colorful.lightblue.alternates[5]
})

gears.table.crush(themeful.batteryIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg,
	bgHl = colorful.lightblue.base,
	bg2Hl = colorful.lightblue.alternates[5]
})

gears.table.crush(themeful.loadScreen, {
	startBg = "#000000",
	targetBg = colorful.background.base,
	imageColor = colorful.green.base,
	imageBg = colorful.background.alternates[2]
})

gears.table.crush(themeful.button, {
	bg = colorful.background.alternates[2],
	fg = colorful.background.on.base,
	bgHover = colorful.lightblue.base,
	fgHover = colorful.lightblue.on.base,
	bgClick = colorful.lightblue.alternates[3],
	fgClick = colorful.lightblue.on.base,
})

gears.table.crush(themeful.timeIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg
})

gears.table.crush(themeful.tagIndicator, {
	bg = colorful.background.base,
	fg = colorful.background.on.base,
	clrNormal = colorful.background.alternates[4],
	clrFocused = colorful.blue.base,
	clrOccupied = colorful.red.base
})

gears.table.crush(themeful.keyboardIndicator, {
	bg = colorful.blue.base,
	fg = colorful.blue.on.base,
	blinkBg = colorful.blue.alternates[3]
})

gears.table.crush(themeful.statusButtons, {
	bgHover = colorful.lightblue.base,
	fgHover = colorful.lightblue.on.base,
	bgClick = colorful.lightblue.alternates[3],
	fgClick = colorful.lightblue.on.base
})

gears.table.crush(themeful.titleButtons, {
  tileBgHover = colorful.lightblue.base,
  tileFgHover = colorful.lightblue.on.base,
  tileBgClick = colorful.lightblue.alternates[3],
  closeBgHover = colorful.red.base,
  closeFgHover = colorful.red.on.base,
  closeBgClick = colorful.red.alternates[3]
})

theme.bg_normal = colorful.background.base
theme.fg_normal = colorful.foreground.alternates[4]
theme.bg_focus = colorful.background.alternates[2]
theme.fg_focus = colorful.foreground.base


theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus
