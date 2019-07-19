local background = wibox.container.background(wibox.widget.textbox(""))
local margin = wibox.container.margin(background)
margin.forced_width = 100
margin.forced_height = 100

local radius = 50

local function testShape(cr, w, h)
	return gears.shape.circle(cr, w, h, radius)
end

background.shape = testShape
background.bg = "#FFFFFF"

animate.addBare({
	updateLoop = function()
		radius = wave(0, 50, 20)
		background:emit_signal("widget::redraw_needed")
	end
})

for i = 1, 5 do
	playground:add(margin)
end
