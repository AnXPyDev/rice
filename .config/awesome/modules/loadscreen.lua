loadscreen = {}

function loadscreen:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function loadscreen:setup(args)
	self.screen = args.screen

	self.config = {}

	themer.apply(
		{
			{"startBg", "#000000"},
			{"targetBg", "#FFFFFF"},
			{"imagePath", PATH.home .. "icons/awesomewm.png"},
			{"imageShape", gears.shape.rectangle},
			{"imageColor", "#AAAAAA"},
			{"imageBg", "#404040"}
		},
		themeful.loadScreen or {}, self.config
	)

	self.animationRunning = false
	self.startColor = colors.new(self.config.startBg)
	self.targetColor = colors.new(self.config.targetBg)
	self.currentColor = colors.new("#000000")
	self.icon = materializeSurface(gears.surface.load(PATH.home .. "icons/awesomewm.png"), {color = self.config.imageColor})
	self.image = wibox.widget.imagebox(self.icon.color)
	self.imageMargin = wibox.container.margin(self.image)
	self.imageMargin.forced_width = dpi(200)
	self.imageMargin.forced_height = dpi(200)
	self.imageBackground = wibox.container.background(self.imageMargin, self.config.imageBg, self.config.imageShape)
	gears.table.crush(self.imageMargin, margins(dpi(20)))
	self.imagePlace = wibox.container.place(self.imageBackground)
	self.imageRadius = 0
	self.image.clip_shape = function(cr, w, h)
		return gears.shape.transform(gears.shape.circle) : translate(dpi(20), dpi(20)) (cr, dpi(200), dpi(200), self.imageRadius)
	end
	self.radiusAnimation = nil
	self.wibox = wibox {
		ontop = true,
		visible = false,
		x = self.screen.geometry.x,
		y = self.screen.geometry.y,
		width = self.screen.geometry.width,
		height = self.screen.geometry.height,
		bg = gears.color.transparent,
		widget = wibox.widget {
			self.imagePlace,
			layout = wibox.layout.flex.horizontal
		}
	}
	return self
end

function loadscreen:animate()
	if not self.animationRunning then
		self.animationRunning = true
		self.imageRadius = 0
		self.radiusAnimation = animate.addBare({
			updateLoop = function()
				self.imageRadius = lerp(self.imageRadius, self.imageMargin.forced_width, 0.07, 0.01)
				if self.imageRadius == self.imageMargin.forced_width then
					return true
				end
				self.image:emit_signal("widget::redraw_needed")
			end
		})
		self:stage1()
	end
end

function loadscreen:stage1()
	self.wibox.opacity = 1
	self.wibox.visible = true
	self.currentColor.H = self.startColor.H
	self.currentColor.S = self.startColor.S
	self.currentColor.L = self.startColor.L
	self.wibox.bg = self.currentColor:to_rgb()
	animate.addBare({
		updateLoop = function()
			self.currentColor.H = lerp(self.currentColor.H, self.targetColor.H, 0.05, 0.01)
			self.currentColor.S = lerp(self.currentColor.S, self.targetColor.S, 0.05, 0.01)
			self.currentColor.L = lerp(self.currentColor.L, self.targetColor.L, 0.05, 0.01)
			self.wibox.bg = self.currentColor:to_rgb()
			if self.currentColor.H == self.targetColor.H and
				self.currentColor.S == self.targetColor.S and
					self.currentColor.L == self.targetColor.L then
						return true
			end
		end,
		callback = function()
			self:stage2()
		end
	})
end

function loadscreen:stage2()
	self.wibox.opacity = 1
	self.wibox.visible = true
	animate.addBare({
		updateLoop = function()
			self.wibox.opacity = lerp(self.wibox.opacity, 0, 0.1, 0.01)
			if self.wibox.opacity == 0 then
				return true
			end
		end,
		callback = function()
			self.wibox.visible = false
			self.wibox.opacity = 1
			self.radiusAnimation.done = true
			self.animationRunning = false
		end
	})
end
