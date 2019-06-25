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
