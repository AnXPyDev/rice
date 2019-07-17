sysgraph = {}

function sysgraph:startRefresh()
	awful.spawn.easy_async_with_shell("bash " .. PATH.config .. "grabcpu.bash",
		function(stdout, stderr, reason, code)
			self:refresh(stdout)
			self.refreshTimer:again()
		end
	)
end

function sysgraph:refresh(output)
	self.graph:add_value(tonumber(output:sub(1,-3)), 1)
end

function sysgraph:setup()
	self.graph = wibox.widget {
		max_value = 100,
		step_width = dpi(5),
		step_spacing = dpi(0),
		step_shape = gears.shape.rounded_bar,
		forced_width = 10000,
		forced_height = 10000,
		background_color = "#202020",
		color = beautiful.bg_focus,
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
	self.graph:add_value(50, 1)
	self.widget = Showcase:new()
		:setup(
			{
				size = {nil, dpi(200)},
				disableText = true,
				showcase = self.graph,
				outsideMargins = margins(0, nil, dpi(10), 0),
				showcaseMargins = margins(0)
			}
					)
end

sysgraph:setup()
