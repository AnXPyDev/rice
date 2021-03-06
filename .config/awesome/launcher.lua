-- /launcher.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--


local launcherConfig = {}

themer.apply(
  {
    {"promptHeight", dpi(60)},
    {"wiboxSize", {nil,nil}},
    {"elementSize", {dpi(130), dpi(120)}},
    {"elementCount", {5,2}},
    {"boundedMargins", margins(0)},
    {{"elementBg", 1}, "#000000"},
    {{"elementBg", 2}, "#000000"},
    {"elementFg", "#FFFFFF"},
    {{"elementBgHl", 1}, "#FFFFFF"},
    {{"elementBgHl", 2}, "#FFFFFF"},
    {"elementFgHl", "#000000"},
    {{"wiboxBg", 1}, "#000000"},
    {{"wiboxBg", 2}, "#000000"},
    {"wiboxShape", gears.shape.rectangle},
    {{"promptBg", 1}, "#FFFFFF"},
    {{"promptBg", 2}, "#FFFFFF"},
    {"promptFg", "#000000"},
    {"promptOutsideMargins", margins(0)},
    {"promptShape", gears.shape.rectangle},
    {"elementOutsideMargins", margins(0)},
    {"elementMargins", margins(dpi(10))},
    {"elementShowcaseMargins", margins(dpi(5))},
    {"elementShape", gears.shape.rectangle},
    {"halign", "center"},
    {"valign", "center"},
    {"showcasePosition", "top"},
    {"boundedValign", "center"},
    {"boundedHalign", "center"},
    {"animate", false}
  },
  themeful.launcher or {}, launcherConfig
)

-- Argument for the SearchMenu instance

local launcherArgs = {
  screen = screens.primary,
  wibox = {
    size = {},
    bg = launcherConfig.wiboxBg,
    shape = launcherConfig.wiboxShape
  },
  prompt = {
    size = {
      nil, launcherConfig.promptHeight
    },
    halign = "left",
    bg = launcherConfig.promptBg,
    fg = launcherConfig.promptFg,
    outsideMargins = launcherConfig.promptOutsideMargins,
    shape = launcherConfig.promptShape
  },
  elements = {
    bg = launcherConfig.elementBg,
    fg = launcherConfig.elementFg,
    bgHl = launcherConfig.elementBgHl,
    fgHl = launcherConfig.elementFgHl,
    size = launcherConfig.elementSize,
		outsideMargins = launcherConfig.elementOutsideMargins,
		margins = launcherConfig.elementMargins,
		boundedMargins = launcherConfig.boundedMargins,
    showcaseMargins = launcherConfig.elementShowcaseMargins,
		hideText = false,
    halign = launcherConfig.halign,
    valign = launcherConfig.valign,
    showcasePosition = launcherConfig.showcasePosition,
    shape = launcherConfig.elementShape,
    boundedValign = launcherConfig.boundedValign,
    boundedHalign = launcherConfig.boundedHalign,
    animate = launcherConfig.animate,

    list = {
      {name = "Emacs", callback = function() awful.spawn("emacs") end, showcase = wibox.widget.imagebox(PATH.icons .. "emacs.png")},
      {name = "Firefox", callback = function() awful.spawn("firefox") end, showcase = wibox.widget.imagebox(PATH.icons .. "firefox.png")},
      {name = "Gimp", callback = function() awful.spawn("gimp") end, showcase = wibox.widget.imagebox(PATH.icons .. "gimp.png")},
      {name = "Terminal", callback = function() awful.spawn("xst") end, showcase = wibox.widget.imagebox(PATH.icons .. "terminal.png")},
      {name = "Minecraft", callback = function() awful.spawn.with_shell("java -jar ~/launcher.jar") end, showcase = wibox.widget.imagebox(PATH.icons .. "minecraft.png")},
      {name = "Team Speak", callback = function() awful.spawn("teamspeak3") end, showcase = wibox.widget.imagebox(PATH.icons .. "teamspeak3.png")},
      {name = "Steam", callback = function() awful.spawn("steam") end, showcase = wibox.widget.imagebox(PATH.icons .. "steam.png")},
      {name = "Libre Office", callback = function() awful.spawn("libreoffice") end, showcase = wibox.widget.imagebox(PATH.icons .. "libreoffice.png")},
      {name = "Codium", callback = function() awful.spawn("codium") end, showcase = wibox.widget.imagebox(PATH.icons .. "codium.png")}
    }
  }
}


launcherArgs.wibox.size[1] = launcherConfig.wiboxSize[1] or launcherConfig.elementCount[1] * launcherArgs.elements.size[1] + launcherArgs.elements.boundedMargins.left + launcherArgs.elements.boundedMargins.right
launcherArgs.wibox.size[2] = launcherConfig.wiboxSize[2] or launcherArgs.prompt.size[2] + launcherConfig.elementCount[2] * launcherArgs.elements.size[2] + launcherArgs.elements.boundedMargins.top + launcherArgs.elements.boundedMargins.bottom

launcherArgs.wibox.pos = {screens.primary.geometry.x + (screens.primary.geometry.width - launcherArgs.wibox.size[1]) / 2, screens.primary.geometry.y + (screens.primary.geometry.height - launcherArgs.wibox.size[2]) / 2}


-- Create launcher with arguments
launcher = SearchMenu:new():setup(launcherArgs)

launcher.animationRunning = false

-- Animates launcher when shown (Slides from top)
function launcher:showAnimate()
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
  -- if not self.wibox.widget.visible then
  --   self.directedBox = self.screen.director:add({
  --     side = "right",
  --     padding = margins(0),
  --     wibox = self.wibox.widget,
  --     priority = 1
  --   })
  --   self:show()
  -- end
  self.wibox.widget.visible = true
end

function launcher:hide()
  self.wibox.widget.visible = false
  self.screen.director:remove(self.directedBox)
end
