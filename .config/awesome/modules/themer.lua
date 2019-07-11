themer = {}

function themer.apply(vars, input, output)
  for key, value in pairs(vars) do
    local splits = gears.string.split(value[1], ".")
    if not string.match(value[1], ".") then
      splits = {value[1]}
      print("nodot")
    end
    for k, v in pairs(splits) do
      print(k, v)
    end
    print(value[1])
    local lastAccess = input
    local lastOutput = output
    for i = 1, #splits do
      print(splits[i])
      if i < #splits then
	lastOutput[splits[i]] = lastOutput[splits[i]] or {}
	lastOutput = lastOutput[splits[i]]
	lastAccess = lastAccess[splits[i]] or nil
	if not lastAccess then
	  break
	end
      else
	lastOutput[splits[i]] = lastAccess[splits[i]] or value[2] or nil
      end
    end
  end
end


local x = {var = 24}
local y = {}

themer.apply({{"var", 12}}, x, y)

print(y.var, "var")
