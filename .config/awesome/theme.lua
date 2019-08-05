themeful = {}
colorful = {}
theme = {}
resourceful = {}

local themeCategory = "dark"

wallpaperFolder = themeCategory
colorschemeNames = {themeCategory .. "/galaxy", themeCategory .. "/base", "resources"}
themeNames = {"material"}

for i, name in ipairs(themeNames) do
	dofile(PATH.theme .. name .. ".lua")
end

for i, name in ipairs(colorschemeNames) do
	dofile(PATH.colorscheme .. name .. ".lua")
end

local xfile = io.open(PATH.home .. ".customXresources", "w")

--for key, value in pairs(resourceful) do
	--xfile:write(key .. ": " .. value .. "\n")
--end

xfile:close()

beautiful.init(theme)
