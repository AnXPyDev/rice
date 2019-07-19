currentWallpaper = ""

-- Recurses until a new wallpaper is found

function setWallpaper()
	awful.spawn.easy_async_with_shell("ls -1A ~/wallpapers/ | shuf -n 1",
		function(stdout, stderr, reason, exit_code)
			local stdout = stdout:sub(1, -2)
			print(currentWallpaper, stdout)
			if stdout == currentWallpaper then
				setWallpaper()
			else
				currentWallpaper = stdout
				for k, screen in pairs(screens.list) do
					local currentWallpaperSurface = gears.surface.load_uncached()
					gears.wallpaper.maximized(PATH.home .. "wallpapers/" .. currentWallpaper, screen)
					collectgarbage()
				end
			end
		end
	)
end
