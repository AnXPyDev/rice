local muteImage = materializeSurface(gears.surface.load(PATH.home .. "icons/volumeMute.png"))
local volumeImage =	materializeSurface(gears.surface.load(PATH.home .. "icons/volume.png"))

local volumesliderArgs = {
  screen = screens.primary,
  wibox = {
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

volumecontrol = {}

function volumecontrol:setup()
  self.slider = volumeslider.sliders.widgets[1].slider
  self.slider.maximum = 150
  self.slider.minimum = 0
  self.isMuted = false
  self.volume = 0
  self.step = 5
  self.recentlyUpdated = false
	self.showcaseAnimation = {}
	self.showcaseColor = colors.new(volumeslider.sliders.config.bg)
  self.aliveTimer = gears.timer {
    timeout = 2,
    single_shot = true,
    callback = function()
      self:hide()
    end
  }
  self.updateTimer = gears.timer {
    timeout = 0.1,
    single_shot = true,
    callback = function()
      self:updateExternal()
    end
  }
  self.refreshTimer = gears.timer {
    timeout = 1,
    autostart = true,
    call_now = true,
    callback = function()
      self:refresh()
    end
  }
  volumeslider.wibox.widget:connect_signal("mouse::enter", function()
    self.aliveTimer:stop()
  end)
  volumeslider.wibox.widget:connect_signal("mouse::leave", function()
    self.aliveTimer:again()
  end)
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

function volumecontrol:refresh()
  self.volume = tonumber(os.capture("pamixer --get-volume"))
  self.isMuted = os.capture("pamixer --get-mute") == "true"
  self:update()
end

function volumecontrol:update()
  self.recentlyUpdated = true
	self.showcaseAnimation.done = true
  if self.isMuted then
    volumeslider.sliders.widgets[1].showcase.image = muteImage.onBackground
    volumeslider.sliders.widgets[1].showcaseBackground.bg = colorful.background
		self.showcaseAnimation = animate.addColor({
			element = volumeslider.sliders.widgets[1].showcaseBackground,
			color = self.showcaseColor,
			targetColor = colors.new(volumeslider.sliders.config.bg),
			amplitude = 0.2,
			treshold = 0.01,
			hue = "color"
		})
  else
    volumeslider.sliders.widgets[1].showcase.image = volumeImage.onPrimary
		self.showcaseAnimation = animate.addColor({
			element = volumeslider.sliders.widgets[1].showcaseBackground,
			color = self.showcaseColor,
			targetColor = colors.new(volumeslider.sliders.config.showcaseBg),
			amplitude = 0.2,
			treshold = 0.01,
			hue = "target"
		})
  end
  self.slider.value = self.volume
end

function volumecontrol:updateExternal()
  awful.spawn.with_shell("pamixer --set-volume " .. tostring(self.volume))
end

function volumecontrol:show()
  if not self.animationRunning and not volumeslider.wibox.widget.visible then
    volumeslider.wibox.widget.visible = true
    self.animationRunning = true
    animate.add({
      object = volumeslider.wibox.widget,
      start = {
	volumesliderArgs.wibox.pos[1],
	volumesliderArgs.wibox.pos[2] + volumesliderArgs.wibox.size[2]
      },
      target = {
	volumesliderArgs.wibox.pos[1],
	volumesliderArgs.wibox.pos[2]
      },
      type = "interpolate",
      magnitude = 0.3,
      callback = function()
	self.animationRunning = false
      end
    })
  end
  self:update()
  self.aliveTimer:again()
end

function volumecontrol:hide()
  volumeslider.wibox.widget.visible = false
end

function volumecontrol:change(sign)
  if sign == -1 then
    awful.spawn.with_shell("pamixer -d " .. tostring(self.step))
  else
    awful.spawn.with_shell("pamixer -i " .. tostring(self.step))
  end
  self.volume = clamp(self.volume + self.step * sign, 0, 150)
  self:show()
end

function volumecontrol:toggleMute()
  awful.spawn.with_shell("pamixer -t")
  self.isMuted = not self.isMuted
  self:show()
end

volumecontrol:setup()
