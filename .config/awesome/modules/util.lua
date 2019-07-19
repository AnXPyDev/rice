function margins(l, r, t, b)
  l = l or 0
  r = r or l
  t = t or r
  b = b or t
  return {
    left = l,
    right = r,
    top = t,
    bottom = b
  }
end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function materializeSurface(surface, colors)
	local colors = colors or
		{
			primary = colorful.primary,
			complementary = colorful.complementary,
			background = colorful.background,
			foreground = colorful.foreground,
			onBackground = colorful.onBackground,
			onForeground = colorful.onForeground,
			onPrimary = colorful.onPrimary,
			onComplementary = colorful.onComplementary
		}

	local result = {}

	for name, color in pairs(colors) do
		result[name] = gears.color.recolor_image(gears.surface.duplicate_surface(surface), color)
	end

	return result
end

function loadScreensAnimate()
	for k, screen in pairs(screens.list) do
		screen.loadScreen:animate()
	end
end
