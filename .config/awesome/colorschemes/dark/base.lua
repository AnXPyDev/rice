gears.table.crush(themeful.titleBar, {
	bgFocus = colorful.background.alternates[3],
	fgFocus = colorful.background.on.base,
	bg = colorful.background.base,
	fg = colorful.background.on.base
})

gears.table.crush(themeful.searchMenu.prompt, {
	bg = colorful.background.alternates[3],
	fg = colorful.background.on.base,
})

gears.table.crush(themeful.searchMenu.elements, {
	bg = colorful.background.base,
	fg = colorful.background.on.base,
	bgHl = colorful.primary.alternates[4],
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
	startBg = "#000000",
	targetBg = colorful.background.base,
	imageColor = colorful.primary.base,
	imageBg = colorful.background.alternates[2]
})

gears.table.crush(themeful.button, {
	bg = colorful.background.alternates[2],
	fg = colorful.background.on.base,
	bgHover = colorful.primary.base,
	fgHover = colorful.primary.on.base,
	bgClick = colorful.primary.alternates[3],
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
	bgHover = colorful.primary.base,
	fgHover = colorful.primary.on.base,
	bgClick = colorful.primary.alternates[3],
	fgClick = colorful.primary.on.base
})

gears.table.crush(themeful.titleButtons, {
  tileBgHover = colorful.secondary.base,
  tileFgHover = colorful.secondary.on.base,
  tileBgClick = colorful.secondary.alternates[3],
  closeBgHover = colorful.alert.base,
  closeFgHover = colorful.alert.on.base,
  closeBgClick = colorful.alert.alternates[3]
})

gears.table.crush(themeful.sysGraph, {
  bg = themeful.showcase.bg,
  fgCpu = colorful.secondary.base,
  fgRam = colorful.primary.base
})

theme.bg_normal = colorful.background.base
theme.fg_normal = colorful.foreground.alternates[4]
theme.bg_focus = colorful.background.alternates[2]
theme.fg_focus = colorful.foreground.base


theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus

