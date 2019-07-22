-- /modules/loadscreen.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

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
			{"imagePath", PATH.icons .. "awesomewm.png"},
			{"imageShape", gears.shape.rectangle},
			{"imageColor", "#AAAAAA"},
			{"imageBg", "#404040"}
		},
		themeful.loadScreen or {}, self.config
	)

	self.animationRunning = false
	self.icon = materializeSurface(gears.surface.load(PATH.icons .. "awesomewm.png"), {color = self.config.imageColor})
	self.image = wibox.widget.imagebox(self.icon.color)
	self.imageMargin = wibox.container.margin(self.image)
	self.imageMargin.forced_width = dpi(200)
	self.imageMargin.forced_height = dpi(200)
	self.imageBackground = wibox.container.background(self.imageMargin, self.config.imageBg, self.config.imageShape)
	gears.table.crush(self.imageMargin, margins(dpi(20)))
	self.imagePlace = wibox.container.place(self.imageBackground)
	self.imageRadius = 0 -- Radius of the icon clip shape
	self.imageAngle = 0 -- End angle of the icon clip shape
	self.image.clip_shape = function(cr, w, h)
		return gears.shape.transform(gears.shape.pie) : translate(dpi(20), dpi(20)) (cr, dpi(200), dpi(200), 0, self.imageAngle, self.imageRadius)
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
		self.imageAngle = 0
		self.radiusAnimation = animate.addBare({
			updateLoop = function()
				self.imageRadius = lerp(self.imageRadius, self.imageMargin.forced_width, 0.07, 0.01)
				self.imageAngle = lerp(self.imageAngle, math.pi * 2, 0.2, 0.01)
				if self.imageRadius == self.imageMargin.forced_width and self.imageAngle == math.pi * 2 then
					return true
				end
				self.image:emit_signal("widget::redraw_needed")
			end
		})
		self:stage1()
	end
end

-- Stage 1 fades colors from start to target

function loadscreen:stage1()
	self.wibox.opacity = 1
	self.wibox.visible = true
	animate.addColor({
		startColor = colors.new(self.config.startBg),
		targetColor = colors.new(self.config.targetBg),
		element = self.wibox,
		index = "bg",
		amplitude = 0.05,
		callback = function()
			self:stage2()
		end
	})
end

-- Stage 2 decrases opacity of wibox and then hides it

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
