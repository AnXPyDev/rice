Vector = function(x, y)
  local xval, yval
  if type x == "table" then
    xval = x[1] or 0
    yval = x[2] or x[1] or 0
  else
    xval = x or 0
    yval = y or x or 0
  end
  return {
    x = xval,
    y = yval
  }
end
