colorful = genColorScheme(
  "#282f37",
  "#f1fcf9",
  {
    red = "#e49186",
    green = "#74dd91",
    blue = "#75dbe1"
  },
  25
)

colorful.primary = colorful.green
colorful.secondary = colorful.red
colorful.alert = colorful.red

resourceful["emacs.themeName"] = "kaolin-galaxy"

resourceFiles[#resourceFiles + 1] = PATH.resources .. "skyfall"

local function schemeExtension()
  themeful.internetIndicator.bgOnline = colorful.red.base
  themeful.internetIndicator.bg2Online = colorful.red.alternates[4]
end

themeFunctions[#themeFunctions + 1] = schemeExtension
