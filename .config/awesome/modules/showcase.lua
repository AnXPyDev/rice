Showcase = {}

function Showcase:new()
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  return ins
end

function Showcase:setup(args)
  self.config = {}
  self.widgets = {}
  self.config.textDisabled = 
  
  local widget = self.widgets

  if not args.disableText and args.text then
    widget.text = wibox.widget.textbox(args.text or "")
    widget.textPlace = wibox.container(widget.text)
  end

  widget.textFinal = widget.textPlace or nil

  if not args.disableShowcase and args.showcase then
    widget.showcaseMargin = wibox.container.margin(args.showcase)
  end

  widget.showcaseFinal = widget.showcaseMargin or nil
  
  local widgets = {
    layout = wibox.layout.fixed.horizontal,
    widget.showcaseFinal,
    widget.textFinal
  }

  

  
end
