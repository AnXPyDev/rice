themeful = {}
colorful = {}
theme = {}
resourceful = {}

resourceFiles = {PATH.resources .. "palenight"}

os.execute("xrdb " .. PATH.home .. ".Xresources")

for i, val in ipairs(resourceFiles) do
  os.execute("xrdb -merge " .. val)
end


local themeCategory = "dark"

wallpaperFolder = themeCategory
colorschemeNames = {themeCategory .. "/palenight", themeCategory .. "/base"}
themeNames = {"material"}

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

os.execute("xrdb -merge " .. PATH.home .. ".customXresources")

beautiful.init(theme)
