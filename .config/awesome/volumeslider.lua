Slider = {}

function Slider:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function Slider:setup(args)
  self.screen = args.screen
  self.wibox = {}
  self.sliders = {}
end
