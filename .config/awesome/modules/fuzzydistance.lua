function fuzzyCharDistance(a, b, lowercaseComparison)
  if lowercaseComparison then
    a = a:lower()
    b = b:lower()
  end

  local matches = {}
  local lastFound = 0
  
  local charIndex = 1

  for charIndex = 1, a:len() do
    local searchResult = b:find(a:sub(charIndex, charIndex), lastFound)
    if searchResult then
      matches[#matches + 1] = searchResult - lastFound
			lastFound = searchResult
		end
	end

	if #matches == 0 then
		return 0
	end

	local averageDistance = 0

	for i = 1, #matches do
		averageDistance = averageDistance + matches[i]
	end

	averageDistance = averageDistance / #matches

	return (#matches / a:len()) * (1 / averageDistance)
	
end

function fuzzyWordCompare(a, b, lowercaseComparison)
  if lowercaseComparison then
    a = a:lower()
    b = b:lower()
  end

  local firstFound, lastFound = 0, 0

  local wordList = gears.string.split(a, " ")

  for k, word in pairs(wordList) do
    firstFound, lastFound = b:find(word, lastFound + 1)
    if not firstFound or nil then return false end
  end

  return true
	
end
