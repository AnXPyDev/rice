function clamp(x, min, max)
  if min and x < min then return min end
  if max and x > max then return max end
  return x
end

function wrap(x, min, max)
  if x < min then
    return max - (min - x)
  elseif x > max then
    return min + (x - max)
  else
    return x
  end
end

function wrapIP(x, min, max)
  if x < min then
    return max
  elseif x > max then
    return min
  else
    return x
  end
end

function lerp(x, target, percentage, treshold)
  treshold = treshold or 0
  if math.abs(target - x) < treshold then
    return target
  end

  return x + (target - x) * percentage
end

function lerpColor(color, target, percentage, treshold)
	color.H = lerp(color.H, target.H, percentage, treshold)
	color.S = lerp(color.S, target.S, percentage, treshold)
	color.L = lerp(color.L, target.L, percentage, treshold)
end

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

function wave(min, max, amp, off)
	local amp = amp or 1
	local off = off or 1
	return (math.sin(amp * os.clock() + off) + 1) / 2 * math.abs(max - min) + min
end
