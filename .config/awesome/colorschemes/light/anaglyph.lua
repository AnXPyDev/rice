colorful = genColorScheme(
  "#FFFFFF",
  "#121212",
  {
    red = "#ef5350",
    lightblue = "#81d4fa"
  },
  25
)

colorful.primary = colorful.lightblue
colorful.secondary = colorful.red
colorful.alert = colorful.red

logTable(colorful, 0, 2)

resourceful["emacs.themeName"] = "kaolin-light"
