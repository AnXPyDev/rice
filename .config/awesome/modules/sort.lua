function inTable(tbl, item)
  for key, value in pairs(tbl) do
    if value == item then return key end
  end
  return false
end

function sortByCharComparison(base, strings, treshold)
  local result = {}
  local percentages = {}

  for i = 1, #strings do
    percentages[i] = fuzzyCharDistance(base, strings[i], true)
  end

  local max = 0
  local sorted = {}
  
  for i = 1, #percentages do
    for i = 1, #percentages do
      if max <= percentages[i] and not inTable(sorted, i) then
	sorted[#sorted + 1] = i
	max = percentages[i]
      end
    end
  end
  
  for i = 1, #sorted do
    i = #sorted - (i - 1)
    if not treshold or percentages[sorted[i]] > treshold then
      result[#result + 1] = strings[sorted[i]]
    end
  end

  return result
end

function sortByWordComparison(base, strings)
  local result = {}
  for i = 1, #strings do
    if fuzzyWordCompare(base, strings[i], true) then
      result[#result + 1] = strings[i]
    end
  end

  return result
  
end
