themeful = {}
colorful = {}
theme = {}
resourceful = {}

resourceFiles = {}
themeFunctions = {}

os.execute("xrdb " .. PATH.home .. ".Xresources")

local themeCategory = "light"

wallpaperFolder = themeCategory
colorschemeNames = {themeCategory .. "/anaglyph", themeCategory .. "/base"}
themeNames = {"material"}

for i, name in ipairs(themeNames) do
	dofile(PATH.theme .. name .. ".lua")
end

for i, name in ipairs(colorschemeNames) do
	dofile(PATH.colorscheme .. name .. ".lua")
end

for i, val in ipairs(resourceFiles) do
  os.execute("xrdb -merge " .. val)
end

for i, fn in ipairs(themeFunctions) do
  fn()
end

local xfile = io.open(PATH.home .. ".customXresources", "w")

for key, value in pairs(resourceful) do
  xfile:write(key .. ": " .. value .. "\n")
end

xfile:close()

os.execute("xrdb -merge " .. PATH.home .. ".customXresources")

beautiful.init(theme)
