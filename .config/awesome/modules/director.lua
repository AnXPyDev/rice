director = {}

function director:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function director:setup(args)
	self.screen = args.screen
	self.queues = {
		left = {}, right = {}, top = {}, bottom = {}
	}
	
	self.coordMultipliers = {
		left = {1, 0},
		right = {-1, 0},
		top = {0, 1},
		bottom = {0, -1}
	}
	
	self.coords = {
		top = self.screen.geometry.y,
		bottom = self.screen.geometry.y + self.screen.geometry.height,
		left = self.screen.geometry.x,
		right = self.screen.geometry.x + self.screen.geometry.width,
		width = self.screen.geometry.width,
		height = self.screen.geometry.height
	}
	return self
end

function director:add(args)
	local side = args.side
	local instance = directedBox:new()
	instance.director = self
	instance.side = side
	instance:setup(args)
	self.queues[side][#self.queues[side] + 1] = instance
	instance.index = #self.queues[side]
	self:findNewPosition(instance)
	return instance
end

function director:remove(instance, side)
	if type(instance) == "table" then
		table.remove(self.queues[instance.side], instance.index)
		self:reorder(instance.side)
	else
		if side then
			table.remove(self.queues[side], instance)
			self:reorder(side)
		else
			return
		end
	end
end

function director:findNewPosition(instance)
	local queue = self.queues[instance.side]
	local initialIndex = instance.index
	table.remove(queue, initialIndex)
	local newIndex = #queue + 1
	for i, val in ipairs(queue) do
		if val.priority > instance.priority then
			newIndex = i
		end
	end
	table.insert(queue, newIndex, instance)
	self:reorder(instance.side)
end

function director:reorder(side)
	local queue = self.queues[side]
	local directionIndex = (side == "left" or side == "right") and 1 or 2
	local pos = 0
	for i, val in ipairs(queue) do
		val.index = i
		val:animateToPos(pos)
		pos = pos + val.paddedSize[directionIndex]
	end
end

directedBox = {}

function directedBox:new()
	local ins = {}
	setmetatable(ins, self)
	self.__index = self
	return ins
end

function directedBox:setup(args)
	self.director = args.director or self.director
	self.side = args.side or self.side
	self.wibox = args.wibox
	self.padding = args.padding or margins(0)
	self.priority = args.priority or 0 -- higher priority goes on top of lower
	self.animation = {}
	self.speed = args.speed or 0.2

	self.size = args.size or {self.wibox.width, self.wibox.height}

	self.paddedSize = {
		self.size[1] + self.padding.left + self.padding.right,
		self.size[2] + self.padding.top + self.padding.bottom
	}

	print(self.size[1] - self.paddedSize[1])
	print(self.size[2] - self.paddedSize[2])

	self.pos = {0,0}

	if self.side == "left" or self.side == "right" then
		self.pos[2] = self.director.coords.top + (self.director.coords.height - self.paddedSize[2]) / 2
		if self.side == "left" then
			self.pos[1] = self.director.coords.left - self.paddedSize[1]
		else
			self.pos[1] = self.director.coords.right
		end
	else
		self.pos[1] = self.director.coords.left + (self.director.coords.width - self.paddedSize[1]) / 2
		if self.side == "top" then
			self.pos[2] = self.director.coords.top - self.paddedSize[2]
		else
			self.pos[2] = self.director.coords.bottom
		end
	end

	self.wibox.x = self.pos[1] + self.padding.left
	self.wibox.y = self.pos[2] + self.padding.top

	self.targetPos = {self.pos[1], self.pos[2]}

	return self
end

function directedBox:animateToPos(pos)
	if self.side == "left" then
		self.targetPos[1] = self.director.coords.left + pos
		self.targetPos[2] = self.pos[2]
	elseif self.side == "right" then
		self.targetPos[1] = self.director.coords.right - (pos + self.paddedSize[1])
		self.targetPos[2] = self.pos[2]
	elseif self.side == "top" then
		self.targetPos[2] = self.director.coords.top + pos
		self.targetPos[1] = self.pos[1]
	elseif self.side == "bottom" then
		self.targetPos[2] = self.director.coords.bottom - (pos + self.paddedSize[2])
		self.targetPos[1] = self.pos[1]
	end
	if not (self.targetPos[1] == self.pos[1] and self.targetPos[2] == self.pos[2]) then
		self.animation.done = true
		self.animation = animate.addBare({
			updateLoop = function()
				self.pos[1] = lerp(self.pos[1], self.targetPos[1], self.speed, 0.01)
				self.pos[2] = lerp(self.pos[2], self.targetPos[2], self.speed, 0.01)
				self.wibox.x = self.pos[1] + self.padding.left
				self.wibox.y = self.pos[2] + self.padding.top
				if self.pos[1] == self.targetPos[1] and self.pos[2] == self.targetPos[2] then
					return true
				end
			end
		})
	end
end
