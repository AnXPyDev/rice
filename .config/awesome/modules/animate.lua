animate = {}
animate.queue = {}
animate.fps = 60

function animate.update()
  for i = 1, #animate.queue do
    if animate.queue[i].done then
      animate.queue[i].callback()
      table.remove(animate.queue, i)
      i = i - 1
    else
      animate.queue[i]:update()
    end
  end
end

function animate.add(args)
  animate.queue[#animate.queue + 1] = animation:new():create(args)
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
  if not self.done then
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
