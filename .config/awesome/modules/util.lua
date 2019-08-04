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


function rgbToArray(rgbString)
	local finalString = ""
	if rgbString:sub(1,1) == "#" then
		finalString = rgbString:sub(2)
	else
		finalString = rgbString
	end
	
	local result = {}
	
	for i = 0, 2 do
		result[#result + 1] = tonumber("0x" .. finalString:sub(i * 2 + 1, i * 2 + 2)) / 255
	end
	
	return result
end

function arrayToRgb(rgbArray)
	local result = "#"

	for i = 1, 3 do
		result = result .. string.format("%02x", math.floor(rgbArray[i]*255 + 0.5))
	end

	return result
end

function genColorScheme(bg, fg, others, alternateCount)

  local function isLight(color)
    return colors.new(color).L > 0.5
  end

  local function alternates(color, count)
    if isLight(color) then
      return gears.table.map(function(color) color:to_rgb() end, colors.new(color):shades(count))
    else
      return gears.table.map(function(color) color:to_rgb() end, colors.new(color):tints(count))
    end
  end

  local alternateCount = alternateCount or 12
  local result = {}

  result.background = {
    base = bg,
    alternates = alternates(bg, alternateCount)
  }

  result.foreground = {
    base = fg,
    alternates = alternates(fg, alternateCount)
  }

  result.background.on = result.foreground
  result.foreground.on = result.background

  local cache = {}
  
  local function getOnColor(color)
    if isLight(color) == isLight(result.background.base) then
      return result.foreground
    else
      return result.background
    end
  end
  
  for key, color in pairs(others) do
    result[key] = cache[color] or {
      base = color,
      alternates = alternates(color, alternateCount),
      on = getOnColor(color)
    }
    cache[color] = cache[color] or result.key
  end

  return result
end

function logTable(tbl, depth, maxDepth)
  local maxDepth = maxDepth or 5
  local depth = depth or 0
  local indent = ""
  if depth > 0 then
    indent = string.rep("-", depth - 1) .. ">"
  end

  if depth > maxDepth then
    return
  end
  
  for key, element in pairs(tbl) do
    if type(element) == "table" then
      print(indent .. " " .. tostring(key) .. ": " )
      logTable(element, depth + 1, maxDepth)
    else
      print(indent .. " " .. tostring(key) .. ": " .. tostring(element))
    end
  end
  
  local depth = 0
end
