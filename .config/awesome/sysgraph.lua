sysgraph = {}

function sysgraph:startRefresh()
	awful.spawn.easy_async_with_shell("bash " .. PATH.config .. "grabsys.bash",
		function(stdout, stderr, reason, code)
			self:refresh(stdout)
			self.refreshTimer:again()
		end
	)
end

function sysgraph:refresh(output)
	output = gears.string.split(output, "\n")
	self.cpugraph:add_value(tonumber(output[1]:sub(1,-2)) * 0.5, 1)
	self.ramgraph:add_value(tonumber(output[2]) * 0.5, 1)
end

function sysgraph:setup()
	self.cpugraph = wibox.widget {
		max_value = 100,
		step_width = dpi(5),
		step_spacing = dpi(0),
		step_shape = gears.shape.rectangle,
		forced_width = 10000,
		forced_height = 10000,
		background_color = gears.color.transparent,
		color = colorful.complementary,
		widget = wibox.widget.graph
	}
	self.ramgraph = wibox.widget {
		max_value = 100,
		step_width = dpi(5),
		step_spacing = dpi(0),
		step_shape = gears.shape.rectangle,
		forced_width = 10000,
		forced_height = 10000,
		background_color = gears.color.transparent,
		color = colorful.primary,
		widget = wibox.widget.graph
	}
	self.refreshTimer = gears.timer {
		timeout = 1,
		autostart = true,
		call_now = true,
		single_shot = true,
		callback = function()
			self:startRefresh()
		end
	}
	self.graph = wibox.widget {
		layout = wibox.layout.stack,
		wibox.container.mirror(self.ramgraph, {vertical = true, horizontal = false}),
		self.cpugraph
	}
	self.widget = Showcase:new()
		:setup(
			{
				size = {nil, dpi(230)},
				disableText = true,
				showcase = self.graph,
				outsideMargins = margins(0, nil, dpi(10), 0),
				showcaseMargins = margins(0)
			}
					)
end

sysgraph:setup()
