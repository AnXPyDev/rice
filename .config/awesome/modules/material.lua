material = {}

function material.makeStrip(color)
	local result = {}
	local bright = tonumber(os.capture("colorman " .. color:sub(2) .. " getBright 1"))
	local roundedBright = math.floor(bright * 10 + 0.5) / 10
	print(bright, roundedBright)
	for i = 1, 10 do
		result[i] = "#" .. os.capture("colorman " .. color:sub(2) .. " / " .. tostring(1 / (i / (roundedBright * 10))))
		print(i, result[i])
	end
	local index = roundedBright * 10
	return {strip = result, index = index}
end
