PhysObject = {}

function PhysObject:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function PhysObject:setup(args)
  self.physbox = args.parent
  self.object = args.object
  self.pos = args.start
  self.target = args.start
  self.size = args.size or {self.object.geometry.width, self.object.geometry.height}
  self.velocity = {0,0}
  self.weight = 0
  self.movable = args.movable or true
end

function PhysObject:update()
  if self.physbox:moveObject(self) then
    self.pos[1] = self.pos[1] + self.velocity[1]
    self.pos[2] = self.pos[2] + self.velocity[2]
  end
end
