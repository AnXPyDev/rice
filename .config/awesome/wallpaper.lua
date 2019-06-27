function setWallpaper()
  for name in io.popen("ls -1A ~/wallpapers | shuf -n 1", "r"):lines() do
    for k, screen in pairs(screens.list) do
      gears.wallpaper.maximized(PATH.home .. "wallpapers/" .. name, screen)
    end
    break
  end
end
