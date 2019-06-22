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

function compareStrings(a, b)
  return (math.max(a:len(), b:len()) - editDistance(a, b)) / math.max(a:len(), b:len())
end
