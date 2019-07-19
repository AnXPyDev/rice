colorful.tintCount = 25
colorful.background = "#FFFFFF"
colorful.foreground = "#121212"
colorful.primary = "#ef5350"
colorful.complementary = "#81d4fa"
colorful.onBackground = colorful.foreground
colorful.onForeground = colorful.background
colorful.onPrimary = colorful.background
colorful.onComplementary = colorful.foreground

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

gears.table.crush(themeful.searchMenu.prompt, {
	bg = colorful.backgroundShades[3],
	fg = colorful.onBackground,
})

gears.table.crush(themeful.searchMenu.elements, {
	bg = colorful.background,
	fg = colorful.onBackground,
	bgHl = colorful.primary,
	fgHl = colorful.onPrimary
})

gears.table.crush(themeful.searchMenu.wibox, {
	bg = colorful.background,
	fg = colorful.onBackground
})

gears.table.crush(themeful.tagIndicator.wibox, {
	bg = colorful.background,
	fg = colorful.onBackground
})

gears.table.crush(themeful.tagIndicator.tags, {
	colors = {
		focused = colorful.primary,
		occupied = colorful.complementary,
		normal = colorful.backgroundShades[4]
	}
})

gears.table.crush(themeful.slider.wibox, {
	bg = colorful.background
})

gears.table.crush(themeful.slider.sliders, {
  sliderArgs = {
    bar_shape = gears.shape.rounded_bar,
    handle_shape = themeful.shape,
    bar_color = colorful.backgroundShades[10],
    handle_color = colorful.primary,
    bar_height = dpi(5)
  },
  sliderBg = colorful.background,
  showcaseBg = colorful.primary,
  bg = colorful.background
})

gears.table.crush(themeful.statusBar.wibox, {
	fg = colorful.onBackground,
  bg = colorful.backgroundShades[4]
})

gears.table.crush(themeful.statusBar.widgets, {
  bg = colorful.background,
	fg = colorful.onBackground
})

gears.table.crush(themeful.showcase, {
	bg = colorful.background,
	fg = colorful.onBackground
})

gears.table.crush(themeful.internetIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg,
	bgOnline = colorful.primary,
	fgOnline = colorful.onPrimary,
	bg2Online = colorful.primaryTints[5]
})

gears.table.crush(themeful.batteryIndicator, {
	bg = themeful.showcase.bg,
	fg = themeful.showcase.fg,
	bgHl = colorful.primary,
	bg2Hl = colorful.primaryTints[5]
})

gears.table.crush(themeful.loadScreen, {
	startBg = "#000000",
	targetBg = colorful.backgroundShades[4],
	imageColor = colorful.primary,
	imageBg = colorful.background
})

theme.bg_normal = colorful.backgroundShades[4]
theme.fg_normal = colorful.foregroundTints[4]
theme.bg_focus = colorful.background
theme.fg_focus = colorful.foreground


theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus
