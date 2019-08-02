themeful = {}
colorful = {}
theme = {}
resourceful = {}

wallpaperFolder = "dark"
local colorschemeNames = {"dark/bubblegum", "dark/base", "resources"}
local themeNames = {"material"}

for i, name in ipairs(themeNames) do
	dofile(PATH.theme .. name .. ".lua")
end

for i, name in ipairs(colorschemeNames) do
	dofile(PATH.colorscheme .. name .. ".lua")
end

local xfile = io.open(PATH.home .. ".customXresources", "w")

for key, value in pairs(resourceful) do
	xfile:write(key .. ": " .. value .. "\n")
end

xfile:close()

beautiful.init(theme)
