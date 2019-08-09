gears.table.crush(themeful.titleBar, {
	bgFocus = colorful.background.alternates[3],
	fgFocus = colorful.background.on.base,
	bg = colorful.background.base,
	fg = colorful.background.on.base
})

gears.table.crush(themeful.searchMenu.prompt, {
	bg = tableRepeat(colorful.background.alternates[4], 2),
	fg = colorful.background.on.base,
})

gears.table.crush(themeful.searchMenu.elements, {
	bg = tableRepeat(colorful.background.base, 2),
	fg = colorful.background.on.base,
	bgHl = tableRepeat(colorful.background.alternates[4], 2),
	fgHl = colorful.background.on.base
})

gears.table.crush(themeful.searchMenu.wibox, {
	bg = tableRepeat(colorful.background.base, 2),
	fg = colorful.background.on.base
})

gears.table.crush(themeful.slider.wibox, {
	bg = colorful.background.base
})

gears.table.crush(themeful.slider.sliders, {

  sliderBg = colorful.background.base,
  showcaseBg = colorful.primary.base,
  bg = colorful.background.base
})

gears.table.crush(themeful.slider.sliders.sliderArgs, {
  bar_color = colorful.background.alternates[4],
  handle_color = colorful.primary.base
})

gears.table.crush(themeful.volumeControl, {
  wiboxBg = colorful.background.base,
  bg = colorful.background.base,
  fg = colorful.background.on.base,
  bgHl = colorful.primary.base,
  fgHl = colorful.primary.on.base
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
	bg2Online = colorful.primary.alternates[6]
})

gears.table.crush(themeful.batteryIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg,
	bgHl = colorful.primary.base,
	bg2Hl = colorful.primary.alternates[6]
})

gears.table.crush(themeful.loadScreen, {
	startBg = tableRepeat("#000000", 2),
	targetBg = tableRepeat(colorful.background.base, 2),
	imageColor = colorful.primary.base,
	imageBg = colorful.background.alternates[2]
})

gears.table.crush(themeful.button, {
	bg = tableRepeat(colorful.background.alternates[2], 2),
	fg = colorful.background.on.base,
	bgHover = {colorful.primary.base, colorful.primary.alternates[6]},
	fgHover = colorful.primary.on.base,
	bgClick = tableRepeat(colorful.primary.alternates[3], 2),
	fgClick = colorful.primary.on.base,
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
	clrOccupied = colorful.secondary.base
})

gears.table.crush(themeful.keyboardIndicator, {
	bg = colorful.secondary.base,
	fg = colorful.secondary.on.base,
	blinkBg = colorful.secondary.alternates[3]
})

gears.table.crush(themeful.statusButtons, {
	fgHover = colorful.primary.on.base,
	bgClick = tableRepeat(colorful.primary.alternates[3], 2),
	fgClick = colorful.primary.on.base
})

gears.table.crush(themeful.titleButtons, {
  tileBgHover = tableRepeat(colorful.background.alternates[6], 2),
  tileFgHover = colorful.background.on.base,
  tileBgClick = tableRepeat(colorful.background.alternates[9], 2),
  closeBgHover = {colorful.alert.base, colorful.alert.alternates[3]},
  closeFgHover = colorful.alert.on.base,
  closeBgClick = tableRepeat(colorful.alert.alternates[3], 2)
})

gears.table.crush(themeful.sysGraph, {
  bg = themeful.showcase.bg,
  fgCpu = colorful.secondary.base,
  fgRam = colorful.primary.base
})

gears.table.crush(themeful.launcher, {
  wiboxBg = colorful.background.base,
  promptBg = colorful.background.alternates[3],
  promptFg = colorful.background.on.base,
  elementBg = colorful.background.base,
  elementFg = colorful.background.on.base,
  elementBgHl = {colorful.primary.base, colorful.background.base},
  elementFgHl = colorful.primary.on.base
})
