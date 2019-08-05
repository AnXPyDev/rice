-- /volumeslider.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

-- Volumecontrol manages the slider and handles volume changes

volumecontrol = {}

function volumecontrol:setup()

  self.isMuted = false
  self.volume = 0
  self.step = 5
  self.recentlyUpdated = false
	self.directedBox = {}

	self.config = {}

	themer.apply(
		{
			{"animate", false},
			{"colorFadeAmplitude", themeful.animate.colorFadeAmplitude or 0.5},
      {"margins", margins(0)},
      {"wiboxBg", "#000000"},
      {"bgHl", "#FFFFFF"},
      {"bg", "#000000"},
      {"fgHl", "#000000"},
      {"fg", "#FFFFFF"},
      {"showcaseShape", gears.shape.rectangle}
		},
		themeful.volumeControl or {}, self.config
	)

  self.icons = {
    mute = materializeSurface(gears.surface.load(PATH.icons .. "volumeMute.png"), {normal = self.config.fg}).normal,
    volume = materializeSurface(gears.surface.load(PATH.icons .. "volume.png"), {normal = self.config.fgHl}).normal
  }

  self.volumesliderArgs = {
    screen = screens.primary,
    wibox = {
      size = {dpi(400), dpi(75)},
      bg = self.config.wiboxBg
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
      showcaseBg = self.config.bg,
      showcaseShape = self.config.showcaseShape,
      list = {{showcase = wibox.widget.imagebox()}},
      outsideMargins = self.config.margins
    }
  }

  self.volumeslider = Slider:new():setup(self.volumesliderArgs)
  
  self.screen = self.volumesliderArgs.screen
  self.slider = self.volumeslider.sliders.widgets[1].slider
  self.slider.maximum = 150
  self.slider.minimum = 0

	if self.config.animate then
		self.colorAnimation = {}
		self.animatedColor = rgbToArray(self.config.bg)
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
  self.volumeslider.wibox.widget:connect_signal("mouse::enter", function()
    self.aliveTimer:stop()
  end)
  self.volumeslider.wibox.widget:connect_signal("mouse::leave", function()
    self.aliveTimer:again()
  end)

	-- Mute/unmute when image is pressed
  self.volumeslider.sliders.widgets[1].showcaseOutsideMargin:connect_signal(
    "button::press",
    function()
      self:toggleMute(true)
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
		self.volumeslider.sliders.widgets[1].showcase.image = self.icons.mute
		newColor = self.config.bg
	else
    self.volumeslider.sliders.widgets[1].showcase.image = self.icons.volume
		newColor = self.config.bgHl
	end

	-- Fade between current and new selected color or set the color if animations are disabled
	if self.config.animate then
		self.colorAnimation.done = true
		self.colorAnimation = animate.addRgbColor({
			element = self.volumeslider.sliders.widgets[1].showcaseBackground,
			color = self.animatedColor,
			targetColor = rgbToArray(newColor),
			amplitude = self.config.colorFadeAmplitude,
			treshold = 0.01,
		})
	else
		self.volumeslider.sliders.widgets[1].showcaseBackground.bg = newColor
	end

  self.slider.value = self.volume
end

function volumecontrol:updateExternal()
  awful.spawn.with_shell("pamixer --set-volume " .. tostring(self.volume))
end

-- If slider is invisible, shows animation and makes it visible
function volumecontrol:show(noRestartTimer)
  if not self.volumeslider.wibox.widget.visible then
    self.volumeslider.wibox.widget.visible = true
		self.directedBox = self.screen.director:add({
			padding = themeful.outsideMargins,
			side = "bottom",
			priority = 0,
			wibox = self.volumeslider.wibox.widget
		})
  end
  self:update()
	if not noRestartTimer then
		self.aliveTimer:again()
	end
end

function volumecontrol:hide()
  self.volumeslider.wibox.widget.visible = false
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
function volumecontrol:toggleMute(noRestartTimer)
  awful.spawn.with_shell("pamixer -t")
  self.isMuted = not self.isMuted
	self:show(noRestartTimer or nil)
end
volumecontrol:setup()
