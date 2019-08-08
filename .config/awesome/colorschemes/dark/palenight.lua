colorful = genColorScheme(
  "#292d3e",
  "#959dcb",
  {
    red = "#f07178",
    yellow = "#ffcb6b",
    blue = "#82aaff",
    green = "#c3e88d",
    purple = "#c792ea",
    lightblue = "#89ddff",
    deepred = "#ff5370"
  },
  25
)

colorful.primary = colorful.lightblue
colorful.secondary = colorful.red
colorful.alert = colorful.deepred

resourceFiles[#resourceFiles + 1] = PATH.resources .. "palenight"

resourceful["emacs.themeName"] = "kaolin-galaxy"
