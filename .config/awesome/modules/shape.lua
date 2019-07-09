gears.shape.sloped_rect = function (cr, w, h, slope_height, slope_side, slope_invert)
  local slope_side = slope_side or "bottom"
  local slope_invert = slope_invert or false

  if not slope_invert then
    if slope_side == "top" then
      cr:move_to(0,0)
      cr:line_to(w, slope_height)
      cr:line_to(w, h)
      cr:line_to(0, h)
    elseif slope_side == "right" then
      cr:move_to(0,0)
      cr:line_to(w, 0)
      cr:line_to(w - slope_height, h)
      cr:line_to(0, h)
    elseif slope_side == "bottom" then
      cr:move_to(0,0)
      cr:line_to(w, 0)
      cr:line_to(w, h)
      cr:line_to(0, h - slope_height)
    elseif slope_side == "left" then
      cr:move_to(0,0)
      cr:line_to(w, 0)
      cr:line_to(w, h)
      cr:line_to(slope_height, h)
    end
  else
    if slope_side == "top" then
      cr:move_to(0, slope_height)
      cr:line_to(w, 0)
      cr:line_to(w, h)
      cr:line_to(0, h)
    elseif slope_side == "right" then
      cr:move_to(0,0)
      cr:line_to(w - slope_height, 0)
      cr:line_to(w, h)
      cr:line_to(0, h)
    elseif slope_side == "bottom" then
      cr:move_to(0,0)
      cr:line_to(w, 0)
      cr:line_to(w, h - slope_height)
      cr:line_to(0, h)
    elseif slope_side == "left" then
      cr:move_to(slope_height, 0)
      cr:line_to(w, 0)
      cr:line_to(w, h)
      cr:line_to(0, h)
    end
  end

  cr:close_path()

end
