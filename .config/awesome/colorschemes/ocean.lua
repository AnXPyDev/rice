os.execute("xrdb -merge " .. PATH.resources .. "palenight")

colorful = genColorScheme(getXrdbColors(), 24)

colorful.primary = colorful.blue
colorful.secondary = colorful.yellow
colorful.alert = colorful.red

resourceful["emacs.themeName"] = "kaolin-galaxy"
