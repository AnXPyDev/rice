-- /launcher.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--


local launcherConfig = {}

-- Arguments for the SearchMenu instance

local launcherArgs = {
  screen = screens.primary,
  wibox = {
    size = {dpi(540), dpi(280 + 60)}
  },
  prompt = {
    size = {
      nil, dpi(60)
    },
    halign = "left",
  },
  elements = {
    size = {
      dpi(100), dpi(120)
    },
		outsideMargins = margins(dpi(5)),
		margins = margins(dpi(10)),
		boundedMargins = margins(dpi(20)),
		hideText = false,
    halign = "center",
    valign = "center",
    showcasePosition = "top",
    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end, showcase = wibox.widget.imagebox(PATH.icons .. "emacs.png")},
      {name = "Firefox", callback = function() awful.spawn("firefox") end, showcase = wibox.widget.imagebox(PATH.icons .. "firefox.png")},
      {name = "Gimp", callback = function() awful.spawn("gimp") end, showcase = wibox.widget.imagebox(PATH.icons .. "gimp.png")},
      {name = "Terminal", callback = function() awful.spawn("xst") end, showcase = wibox.widget.imagebox(PATH.icons .. "terminal.png")},
      {name = "Minecraft", callback = function() awful.spawn.with_shell("java -jar ~/launcher.jar") end, showcase = wibox.widget.imagebox(PATH.icons .. "minecraft.png")},
      {name = "Team Speak", callback = function() awful.spawn("teamspeak3") end, showcase = wibox.widget.imagebox(PATH.icons .. "teamspeak3.png")},
      {name = "Steam", callback = function() awful.spawn("steam") end, showcase = wibox.widget.imagebox(PATH.icons .. "steam.png")},
      {name = "Libre Office", callback = function() awful.spawn("libreoffice") end, showcase = wibox.widget.imagebox(PATH.icons .. "libre_office.png")}
    }
  }
}

launcherArgs.wibox.pos = {screens.primary.geometry.x + (screens.primary.geometry.width - launcherArgs.wibox.size[1]) / 2, screens.primary.geometry.y + (screens.primary.geometry.height - launcherArgs.wibox.size[2]) / 2}


-- Create launcher with arguments
launcher = SearchMenu:new():setup(launcherArgs)

launcher.animationRunning = false

-- Animates launcher when shown (Slides from top)
function launcher.showAnimate()
  if not launcher.animationRunning and not launcher.wibox.widget.visible then
    launcher.animationRunning = true
    animate.add({
      object = launcher.wibox.widget,
      start = {
        launcherArgs.wibox.pos[1],
        screens.primary.geometry.y - (launcherArgs.wibox.size[2])
      },
      target = {
        launcherArgs.wibox.pos[1],
        launcherArgs.wibox.pos[2]
      },
      type = "interpolate",
      magnitude = 0.3,
      amount = 5,
      callback = function()
        launcher.animationRunning = false
      end
    })
  end
  launcher:show()
end

