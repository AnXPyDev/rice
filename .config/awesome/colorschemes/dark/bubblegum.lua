colorful.background = "#14171e"
colorful.foreground = "#d4d4d6"
colorful.primary = "#62d2db"
colorful.complementary = "#e55c7a"
colorful.onBackground = colorful.foreground
colorful.onForeground = colorful.background
colorful.onPrimary = colorful.background
colorful.onComplementary = colorful.foreground
resourceful["emacs.themeName"] = "kaolin-bubblegum"

colorful = genColorScheme(
  "#14171e",
  "#d4d4d6",
  {
    red = "#e55c7a",
    yellow = "#dbac66",
    lightblue = "#41b0f3",
    green = "#63e8c1",
    purple = "#ce8ec8"
  },
  25
)

colorful.primary = colorful.lightblue
colorful.secondary = colorful.yellow
colorful.alert = colorful.red

resourceful["emacs.themeName"] = "kaolin-bubblegum"
