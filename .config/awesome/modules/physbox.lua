-- WARNING:Probably not going to finish this
--[[
	This was supposed to be a physics engine, for wiboxes, used for moving
	them out of way when a new one appears and stuff like that ...
]]--

PhysObject = {}

function PhysObject:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function PhysObject:setup(args)
  self.id = args.id or nil
  self.physbox = args.parent
  self.object = args.object
  self.margin = args.margin or 0
  self.pos = {
    args.start[1] - self.margin,
    args.start[2] - self.margin
  }
  self.object.x = self.pos[1]
  self.object.y = self.pos[2]
  self.target = args.start
  self.size = {self.object.geometry.width + self.margin * 2, self.object.geometry.height + self.margin * 2}
  self.velocity = {0,0}
  self.weight = 0
  self.movable = args.movable or true
  return self
end

function PhysObject:update()
  self.physbox:moveObject(self)
  self.object.x = self.pos[1] + self.margin
  self.object.y = self.pos[2] + self.margin
end

PhysBox = {}

function PhysBox:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function PhysBox:setup(args)
  self.screen = args.screen or nil
  self.bounds = args.bounds or nil
  if not self.bounds and self.screen then
    self.bounds = {
      self.screen.geometry.x,
      self.screen.geometry.y,
      self.screen.geometry.x + self.screen.geometry.width,
      self.screen.geometry.y + self.screen.geometry.height
    }
  end
  self.instances = {}
end

function PhysBox:collides(object1, object2)
  local x1 = object1.pos[1] + object1.velocity[1]
  local x2 = object2.pos[1] + object2.velocity[1]
  local y1 = object1.pos[2] + object1.velocity[2]
  local y2 = object2.pos[2] + object2.velocity[2]
  
  if x1 < x2 + object2.size[1] and x2 < x1 + object1.size[1] and y1 < y2 + object2.size[2] and y2 < y1 + object1.size[2] then
    return true
  end
  return false
end

function PhysBox:moveObject(object)
  local colisions = {}
  for i = 1, #self.instances do
    if not i == object.id and self:collides(object, self.instances) then

    end
  end
end

function PhysBox:update()
  for i = 1, #self.instances do
    self.instances[i]:update()
    if self.instances[i].dead 
      table.remove(self.instances, i)
      i = i - 1
    end
  end
end
