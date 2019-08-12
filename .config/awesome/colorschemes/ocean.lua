os.execute("xrdb -merge " .. PATH.resources .. "ocean")

colorful = genColorScheme(getXrdbColors(), 24)

colorful.primary = colorful.blue
colorful.secondary = colorful.red
colorful.alert = colorful.red

resourceful["emacs.themeName"] = "kaolin-galaxy"

local function schemeExtension()
  themeful.internetIndicator.bgOnline = {colorful.blue.base, colorful.cyan.base}
end

themeFunctions[#themeFunctions + 1] = schemeExtension
