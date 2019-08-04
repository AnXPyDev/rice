function fuzzyDistance(a, b, lowercaseComparison)
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
