-- /modules/math.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

-- Clamps a value between two values e.g. clamp(100, 0, 1) -> 1

function clamp(x, min, max)
  if min and x < min then return min end
  if max and x > max then return max end
  return x
end

-- Wraps a value around min and max

function wrap(x, min, max)
  if x < min then
    return max - (min - x)
  elseif x > max then
    return min + (x - max)
  else
    return x
  end
end

-- Wraps a value around min and max but doesn't add the overshoot

function wrapIP(x, min, max)
  if x < min then
    return max
  elseif x > max then
    return min
  else
    return x
  end
end

-- Linearly interpolates between two values, if difference is less than treshold, returns target value

function lerp(x, target, percentage, treshold)
  treshold = treshold or 0
  if math.abs(target - x) < treshold then
    return target
  end

  return x + (target - x) * percentage
end

-- Linearly interpolates between two colors' HSV values using lerp

function lerpColor(color, target, percentage, treshold)
	color.H = lerp(color.H, target.H, percentage, treshold)
	color.S = lerp(color.S, target.S, percentage, treshold)
	color.L = lerp(color.L, target.L, percentage, treshold)
end

-- Approaches target value by ammount

function approach(x, target, amount)
  amount = math.abs(amount)
  if math.abs(target - x) < amount then
    return target
  end
  if target < x then
    return x - amount
  elseif target > x then
    return x + amount
  end
end

-- Uses sine wave to "wave" a value between min and max

function wave(min, max, amp, off)
	local amp = amp or 1
	local off = off or 1
	return (math.sin(amp * os.clock() + off) + 1) / 2 * math.abs(max - min) + min
end
