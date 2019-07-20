animate = {}
animate.queue = {}
animate.fps = 60

function animate.update()
	local i = 1
	while true do
		if i > #animate.queue then
			break
		end
    if animate.queue[i].done then
			if animate.queue[i].callback then
				animate.queue[i].callback()
			end
      table.remove(animate.queue, i)
    else
      animate.queue[i]:update()
			i = i + 1
    end
  end
end

function animate.add(args)
  animate.queue[#animate.queue + 1] = animation:new():create(args)
	return animate.queue[#animate.queue]
end

function animate.addBare(args)
  animate.queue[#animate.queue + 1] = bareAnimation:new():create(args)
	return animate.queue[#animate.queue]
end

function animate.addColor(args)
  animate.queue[#animate.queue + 1] = colorAnimation:new():create(args)
	return animate.queue[#animate.queue]
end
animate.timer = gears.timer {
  autostart = true,
  timeout = 1 / animate.fps,
  call_now = true,
  callback = animate.update
}

animation = {}

function animation:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function animation:create(args)
  self.object = args.object
  self.callback = args.callback or nil
  self.type = args.type or "linear"
  self.start = args.start or {nil, nil}
  self.target = args.target
  self.amount = args.amount or 1
	self.paused = false
  self.magnitude = args.magnitude or 0.5
  self.object.x = self.start[1] or self.object.x
  self.object.y = self.start[2] or self.object.y
  self.actualPos = {
    self.start[1] or self.object.x,
    self.start[2] or self.object.y
  }
  self.done = false
  return self
end

function animation:update()
  if not self.done and not self.paused then
    if self.type == "linear" then
      self.actualPos[1] = approach(self.actualPos[1], self.target[1], self.amount)
      self.actualPos[2] = approach(self.actualPos[2], self.target[2], self.amount)
    elseif self.type == "interpolate" then
      self.actualPos[1] = lerp(self.actualPos[1], self.target[1], self.magnitude, 0.2)
      self.actualPos[2] = lerp(self.actualPos[2], self.target[2], self.magnitude, 0.2)
    else
      self:cancel()
    end
    self.object.x = self.actualPos[1]
    self.object.y = self.actualPos[2]
    if self.actualPos[1] == self.target[1] and self.actualPos[2] == self.target[2] then
      self:cancel()
    end
  end
end

function animation:cancel()
  self.done = true
end

bareAnimation = {}

function bareAnimation:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function bareAnimation:create(args)
	self.updateLoop = args.updateLoop
	self.callback = args.callback or nil
	self.paused = false
	self.done = false
	return self
end

function bareAnimation:update()
	if not self.done and not self.paused then
		if self.updateLoop() == true then
			self.done = true
		end
	end
end

colorAnimation = {}

function colorAnimation:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function colorAnimation:create(args)
	self.element = args.element
	self.index = args.index or "bg"
	self.startColor = args.startColor or nil
	self.targetColor = args.targetColor or colors.new("#FFFFFF")
	self.color = args.color or colors.new("#000000")
	if self.startColor then
		self.color.H = self.startColor.H
		self.color.S = self.startColor.S
		self.color.L = self.startColor.L
	end
	if args.hue then
		if args.hue == "color" then
			self.targetColor.H = self.color.H
		elseif args.hue == "target" then
			self.color.H = self.targetColor.H
		end
	end
	self.amp = args.amplitude or 0.5
	self.treshold = args.treshold or 0.01
	self.callback = args.callback or nil
	self.paused = false
	self.done = false
	return self
end

function colorAnimation:update()
	if not self.done and not self.paused then
		lerpColor(self.color, self.targetColor, self.amp, self.treshold)
		self.element[self.index] = self.color:to_rgb()
		if self.color.H == self.targetColor.H and
			self.color.S == self.targetColor.S and
				self.color.L == self.targetColor.L then
					self.done = true
		end
	end
end
