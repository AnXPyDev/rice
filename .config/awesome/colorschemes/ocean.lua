os.execute("xrdb -merge " .. PATH.resources .. "ocean")

colorful = genColorScheme(getXrdbColors(), 24)

colorful.primary = colorful.blue
colorful.secondary = colorful.red
colorful.alert = colorful.red

resourceful["emacs.themeName"] = "kaolin-galaxy"

local function schemeExtension()
  themeful.internetIndicator.bgOnline = {colorful.blue.base, colorful.cyan.base}
  themeful.internetIndicator.bg2Online = colorful.blue.alternates[4]

  themeful.keyboardIndicator.bg = {colorful.red.base, colorful.redAlt.base}
  themeful.keyboardIndicator.blinkBg = {colorful.red.alternates[4], colorful.redAlt.alternates[4]}
 
end

themeFunctions[#themeFunctions + 1] = schemeExtension
