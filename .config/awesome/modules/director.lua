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
	}		left = {}, right = {}, top = {}, bottom = {}


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
end

function director:add(args)
	local side = args.side
	local instance = direcedBox:new()
	instance.director = self
	instance.side = side
	instance:setup(args)
	self.queues[side][#self.queues[side]] = instance
	instance.index = #self.queues.side
	self:findNewPosition(instance)
end

function director:findNewPosition(instance)
	local subIndex = nil
	local subTable1 = {}
	local subTable2 = {}
	for i, val in ipairs(self.queues[instance.side]) do
		if val.priority > instance.priority then
			subIndex = val
		end
	end
	subIndex = subIndex or #self.queues[instance.side]

	
	
end	

local directedBox = {}

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
	self.animation = nil
	self.size = args.size or {self.wibox.width, self.wibox.height}

	self.paddedSize = {
		self.size[1] + self.padding.left, self.padding.right,
		self.size[2] + self.padding.top, self.padding.bottom
	}

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

end

function directedBox:animateToPos()
