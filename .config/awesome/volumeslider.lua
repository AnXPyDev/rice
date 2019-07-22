-- /volumeslider.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

-- Load icons

local muteImage = materializeSurface(gears.surface.load(PATH.icons .. "volumeMute.png"))
local volumeImage =	materializeSurface(gears.surface.load(PATH.icons .. "volume.png"))

-- Args to initialize the slider with

local volumesliderArgs = {
  screen = screens.primary,
  wibox = {
		-- Placed on the bottom middle of the screen 
    pos = {
      screens.primary.geometry.x + (screens.primary.geometry.width - dpi(400)) / 2,
      screens.primary.geometry.y + (screens.primary.geometry.height - (dpi(75) + dpi(10)))
    },
    size = {dpi(400), dpi(75)}
  },
  sliders = {
    margins = margins(0),
    direction = "horizontal",
    showcasePosition = "left",
    sliderSize = {dpi(400)},
    showcaseSize = {dpi(100)},
		sliderMargins = margins(dpi(10), nil, dpi(15)),
		showcaseMargins = margins(dpi(15)),
		showcaseOutsideMargins = margins(0),
    list = {{showcase = wibox.widget.imagebox(volumeImage.onPrimary)}}
  }
}

volumeslider = Slider:new():setup(volumesliderArgs)

-- Volumecontrol manages the slider and handles volume changes

volumecontrol = {}

function volumecontrol:setup()
	self.screen = volumesliderArgs.screen
  self.slider = volumeslider.sliders.widgets[1].slider
  self.slider.maximum = 150
  self.slider.minimum = 0
  self.isMuted = false
  self.volume = 0
  self.step = 5
  self.recentlyUpdated = false
	self.directedBox = {}

	self.config = {}

	themer.apply(
		{
			{"animate", false}
		},
		themeful.volumeControl or {}, self.config
	)

	if self.config.animate then
		self.colorAnimation = {}
		self.animatedColor = colors.new(volumeslider.sliders.config.bg)
	end

	--  the widget after a certain amount of time
  self.aliveTimer = gears.timer {
    timeout = 2,
    single_shot = true,
    callback = function()
      self:hide()
    end
  }

	-- Prevents too many calls to pamixer when changing volume
  self.updateTimer = gears.timer {
    timeout = 0.1,
    single_shot = true,
    callback = function()
      self:updateExternal()
    end
  }

	-- Grabs info from pamixer
  self.refreshTimer = gears.timer {
    timeout = 1,
    autostart = true,
    call_now = true,
    callback = function()
      self:refresh()
    end
  }
	
	-- Disables alive timer while mouse is in wibox
  volumeslider.wibox.widget:connect_signal("mouse::enter", function()
    self.aliveTimer:stop()
  end)
  volumeslider.wibox.widget:connect_signal("mouse::leave", function()
    self.aliveTimer:again()
  end)

	-- Mute/unmute when image is pressed
  volumeslider.sliders.widgets[1].showcaseOutsideMargin:connect_signal(
    "button::press",
    function()
      self:toggleMute()
    end
								      )
  self.slider:connect_signal("property::value", function()
    if not self.recentlyUpdated then
      self.volume = self.slider.value
      self:updateExternal()
    end
    self.recentlyUpdated = false
  end)
end

-- Grabs info from pamixer
function volumecontrol:refresh()
  self.volume = tonumber(os.capture("pamixer --get-volume"))
  self.isMuted = os.capture("pamixer --get-mute") == "true"
  self:update()
end

-- Changes value of slider, icon, and color (can animate) based on current information
function volumecontrol:update()
  self.recentlyUpdated = true
	local newColor = ""

	-- Set icon of slider
	if self.isMuted then
		volumeslider.sliders.widgets[1].showcase.image = muteImage.onBackground
		newColor = volumeslider.sliders.config.bg
	else
    volumeslider.sliders.widgets[1].showcase.image = volumeImage.onPrimary
		newColor = volumeslider.sliders.config.showcaseBg
	end

	-- Fade between current and new selected color or set the color if animations are disabled
	if self.config.animate then
		self.colorAnimation.done = true
		self.colorAnimation = animate.addColor({
			element = volumeslider.sliders.widgets[1].showcaseBackground,
			color = self.animatedColor,
			targetColor = colors.new(newColor),
			amplitude = 0.2,
			treshold = 0.01,
			hue = self.isMuted and "color" or "target"
		})
	else
		volumeslider.sliders.widgets[1].showcaseBackground.bg = newColor
	end

  self.slider.value = self.volume
end

function volumecontrol:updateExternal()
  awful.spawn.with_shell("pamixer --set-volume " .. tostring(self.volume))
end

-- If slider is invisible, shows animation and makes it visible
function volumecontrol:show()
  if not volumeslider.wibox.widget.visible then
    volumeslider.wibox.widget.visible = true
		self.directedBox = self.screen.director:add({
			padding = themeful.outsideMargins,
			side = "bottom",
			priority = 0,
			wibox = volumeslider.wibox.widget
		})
  end
  self:update()
  self.aliveTimer:again()
end

function volumecontrol:hide()
  volumeslider.wibox.widget.visible = false
	self.screen.director:remove(self.directedBox)
end

-- Increases or decreases volume
function volumecontrol:change(sign)
  if sign == -1 then
    awful.spawn.with_shell("pamixer -d " .. tostring(self.step))
  else
    awful.spawn.with_shell("pamixer -i " .. tostring(self.step))
  end
  self.volume = clamp(self.volume + self.step * sign, 0, 150)
  self:show()
end

-- Toggles mute
function volumecontrol:toggleMute()
  awful.spawn.with_shell("pamixer -t")
  self.isMuted = not self.isMuted
  self:show()
end

volumecontrol:setup()
