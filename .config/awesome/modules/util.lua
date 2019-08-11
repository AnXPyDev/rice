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
  if type(rgbString) == "table" then
    return gears.table.map(rgbToArray, rgbString)
  end

  local rgbString = rgbString or "#00000000"

  if rgbString:sub(1,1) == "#" then rgbString = rgbString:sub(2) end

	local result = {}
	
	for i = 0, 3 do
    local sub = rgbString:sub(i * 2 + 1, i * 2 + 2)
    if sub and sub:len() == 2 then
      result[i + 1] = tonumber("0x" .. sub) / 255
    else
      result[i + 1] = 1
    end
	end
	
	return result
end

function arrayToRgb(rgbArray)
	local result = "#"

	for i = 1, 4 do
		result = result .. string.format("%02x", math.floor(rgbArray[i]*255 + 0.5))
	end

	return result
end

function genColorScheme(scheme, alternateCount)

  local function isLight(color)
    return colors.new(color).L > 0.5
  end

  local function alternates(color, count)
    if isLight(color) then
      return gears.table.map(function(c) return c:to_rgb() end, colors.new(color):shades(count))
    else
      return gears.table.map(function(c) return c:to_rgb() end, colors.new(color):tints(count))
    end
  end

  local alternateCount = alternateCount or 12
  local result = {}

  
  
  result.background = {
    base = scheme.background,
    alternates = alternates(scheme.background, alternateCount)
  }

  result.foreground = {
    base = scheme.foreground,
    alternates = alternates(scheme.foreground, alternateCount)
  }

  result.background.on = result.foreground
  result.foreground.on = result.background

  local cache = {}

  cache[result.background.base] = result.background
  cache[result.foreground.base] = result.foreground

  local function getOnColor(color)
    if isLight(color) == isLight(result.background.base) then
      return result.foreground
    else
      return result.background
    end
  end
  
  for key, color in pairs(scheme) do
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
  local indent = string.rep("-", depth) .. ">"

  if depth > maxDepth then
    return
  end

  for key, element in pairs(tbl) do
    if type(element) == "table" then
      print(indent .. " " .. tostring(key) .. ":")
      logTable(element, depth + 1, maxDepth)
    else
      print(indent .. " " .. tostring(key) .. ": " .. tostring(element))
    end
  end
end

function tableEq(tbl1, tbl2)
  for key, val in pairs(tbl1) do
    if tbl2[key] ~= val then
      if type(tbl2[key]) == "table" and type(val) == "table" then
        if not tableEq(tbl2[key], val) then
          return false
        end
      else
        return false
      end
    end
  end
  return true
end

function tableRepeat(val, n)
  local result = {}
  for i = 1, n do
    result[#result + 1] = val
  end
  return result
end

function extractMargin(margins, orientation)
  if orientation == "vertical" then
    return margins.top + margins.bottom
  else
    return margins.left + margins.right
  end
end

function colorsToPattern(colorTable, template)
  local stops = {}

  stops[1] = {0, colorTable[1]}
  stops[2] = {1, colorTable[2]}
  -- for i, val in ipairs(colorTable) do
  --   stops[#stops + 1] = {(1 / #colorTable) * (i - 1), val}
  -- end
  return gears.table.join(template, {stops = stops})
end

function setChannel(rgbString, channel, val)
  local temp = rgbToArray(rgbString)
  temp[channel] = val
  return arrayToRgb(temp)
end

function getXrdbColors(translationTable)
  local translationTable = translationTable or
    {
      "black",
      "red",
      "green",
      "yellow",
      "blue",
      "purple",
      "cyan",
      "white",
      "blackAlt",
      "redAlt",
      "greenAlt",
      "yellowAlt",
      "blueAlt",
      "purpleAlt",
      "cyanAlt",
      "whiteAlt"
    }

  local xres = xresources.get_current_theme()

  for i, key in ipairs(translationTable) do
    xres[key] = xres["color" .. tostring(i - 1)] or "#FFFFFF"
  end

  return xres
  
end
