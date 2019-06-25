function set_wallpaper(screen)
  local file = io.popen("ls -1A ~/wallpapers | shuf -n 1", "r")
  local name = string.sub(file:read("*all"), 1, -2)
  file:close()
  gears.wallpaper.maximized(PATH.home .. "wallpapers/" .. name, screen)
end
