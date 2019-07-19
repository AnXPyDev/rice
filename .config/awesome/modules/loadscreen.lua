loadscreen = {}

function loadscreen:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function loadscreen:setup(args)
	self.screen = args.screen
	self.startColor = colors.new("#000000")
	self.targetColor = colors.new(colorful.background)
	self.currentColor = colors.new("#000000")
	self.wibox = wibox {
		ontop = true,
		visible = false,
		x = self.screen.geometry.x,
		y = self.screen.geometry.y,
		width = self.screen.geometry.width,
		height = self.screen.geometry.height,
		bg = "#000000"
	}
	return self
end

function loadscreen:stage1()
	self.wibox.opacity = 1
	self.wibox.visible = true
	self.currentColor.H = self.targetColor.H
	self.currentColor.S = self.startColor.S
	self.currentColor.L = self.startColor.L
	self.wibox.bg = self.currentColor:to_rgb()
	animate.addBare({
		updateLoop = function()
			self.currentColor.H = lerp(self.currentColor.H, self.targetColor.H, 0.5, 0.1)
			self.currentColor.S = lerp(self.currentColor.S, self.targetColor.S, 0.5, 0.1)
			self.currentColor.L = lerp(self.currentColor.L, self.targetColor.L, 0.5, 0.1)
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
			self.wibox.opacity = lerp(self.wibox.opacity, 0, 0.05, 0.01)
			if self.wibox.opacity == 0 then
				return true
			end
		end,
		callback = function()
			self.wibox.visible = false
			self.wibox.opacity = 1
		end
	})
end
