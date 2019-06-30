local muteImage = gears.surface.load(PATH.home .. "icons/volumeMute.png")
local volumeImage = gears.surface.load(PATH.home .. "icons/volume.png")
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
    bg = "#101010",
    sliderBg = "#202020",
    direction = "horizontal",
    showcasePosition = "left",
    sliderSize = {dpi(400)},
    showcaseSize = {dpi(75)},
    sliderMargins = margins(dpi(20), dpi(20), dpi(10), dpi(10)),
    showcaseMargins = margins(dpi(16)),
    outsideMargins = margins(dpi(5)),
    list = {{showcase = wibox.widget.imagebox(volumeImage)}}
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
      self.updateTimer:again()
    end
    self.recentlyUpdated = false
  end)
end

function volumecontrol:refresh()
  self.volume = tonumber(gears.string.split(os.capture("pulsemixer --get-volume"), " ")[1])
  self.isMuted = tonumber(os.capture("pulsemixer --get-mute")) == 1
end

function volumecontrol:update()
  self.recentlyUpdated = true
  if self.isMuted then
    volumeslider.sliders.widgets[1].showcase.image = muteImage
    volumeslider.sliders.widgets[1].showcaseBackground.bg = "#202020"
  else
    volumeslider.sliders.widgets[1].showcase.image = volumeImage
    volumeslider.sliders.widgets[1].showcaseBackground.bg = volumeslider.sliders.config.showcaseBg
  end
  self.slider.value = self.volume
end

function volumecontrol:updateExternal()
  awful.spawn.with_shell("pulsemixer --set-volume " .. tostring(self.volume))
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
  self:refresh()
  self:update()
  self.aliveTimer:again()
end

function volumecontrol:hide()
  volumeslider.wibox.widget.visible = false
end

function volumecontrol:change(sign)
  sign = sign or 1
  awful.spawn.with_shell("pulsemixer --change-volume " .. tostring(self.step * sign))
  self:show()
end

function volumecontrol:toggleMute()
  awful.spawn.with_shell("pulsemixer --toggle-mute")
  self:show()
end

volumecontrol:setup()
