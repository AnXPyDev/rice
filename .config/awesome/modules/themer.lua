themer = {}

function themer.apply(vars, input, output)
  for key, value in pairs(vars) do
    local splits = type(value[1]) == "table" and value[1] or gears.string.split(value[1], "%.")
    print(value[1])
    local lastAccess = input
    local lastOutput = output
    for i = 1, #splits do
      print(splits[i])
      if i < #splits then
				lastOutput[splits[i]] = lastOutput[splits[i]] or {}
				lastOutput = lastOutput[splits[i]]
				lastAccess = lastAccess and lastAccess[splits[i]] or nil
      else
				lastOutput[splits[i]] = lastAccess[splits[i]] or value[3] and value[2]() or value[2] or lastOutput[splits[i]] or nil
      end
    end
  end
  return input
end
