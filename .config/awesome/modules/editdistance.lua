function getSubString(str, pos)
  if not (pos > str:len() or pos < 1) then
    return str:sub(pos,pos)
  else
    return ""
  end
end

function editDistance(a, b)
  local matrixSize = 0
  if a:len() > b:len() then
    matrixSize = a:len()
  else
    matrixSize = b:len()
  end

  local matrix = {}

  for x = 1, matrixSize + 1 do
    matrix[x] = {}
    for y = 1, matrixSize + 1 do
      matrix[x][y] = 0
    end
  end

  local val = 0
  for x = 1, matrixSize + 1 do
    if not getSubString(a, x - 1) == "" then
      val = val + 1
    end
    matrix[x][1] = val
  end

  val = 0
  
  for y = 1, matrixSize + 1 do
    if not getSubString(b, y - 1) == "" then
      val = val + 1
    end
    matrix[1][y] = val
  end

  for x = 2, matrixSize + 1 do
    for y = 2, matrixSize + 1 do
      local mod = 1
      if getSubString(a, x - 1) == getSubString(b, y - 1) then
	mod = 0
      end
      matrix[x][y] = math.min(matrix[x - 1][y], matrix[x][y - 1], matrix[x - 1][y - 1]) + mod
    end
  end

  return matrix[matrixSize + 1][matrixSize + 1]
end


function compareStrings(a, b, isMin)
  local dist = 0
  a = a:lower()
  b = b:lower()
  if stringdistance then
    dist = stringdistance.lev(a, b)
  else
    dist = editDistance(a, b)
  end
  
  if isMin then
    return (math.max(a:len(), b:len()) - dist) / math.min(a:len(), b:len())
  else
    return (math.max(a:len(), b:len()) - dist) / math.max(a:len(), b:len())
  end
  if mnum == 0 then
    return 1
  end
end
