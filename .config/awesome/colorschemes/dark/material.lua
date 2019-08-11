colorful = genColorScheme(
  "#111622",
  "#cecccf",
  {
    red = "#e06c75",
    green = "#99c794",
    blue = "#6699cc",
    yellow = "#fac863",
    purple = "#c594c5",
    cyan = "#5fb3b3"
  },
  25
)

colorful.primary = colorful.blue
colorful.secondary = colorful.red
colorful.alert = colorful.red

resourceful["emacs.themeName"] = "xresources"

resourceFiles[#resourceFiles + 1] = PATH.resources .. "testing"

local function schemeExtension()

end

themeFunctions[#themeFunctions + 1] = schemeExtension
