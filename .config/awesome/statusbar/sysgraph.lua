-- /sysgraph.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

sysgraph = {}

-- Starts refreshing info using async call to a script

function sysgraph:startRefresh()
	awful.spawn.easy_async_with_shell("bash " .. PATH.config .. "grabsys.bash",
		function(stdout, stderr, reason, code)
			self:refresh(stdout)
			-- Start refreshing again
			self.refreshTimer:again()
		end
	)
end

-- Adds values to graphs

function sysgraph:refresh(output)
	output = gears.string.split(output, "\n")
	self.cpugraph:add_value(tonumber(output[1]:sub(1,-2)) * 0.5, 1)
	self.ramgraph:add_value(tonumber(output[2]) * 0.5, 1)
	-- Values are halved so the graphs don't overlap
end

-- Initializes sysgraph
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
				outsideMargins = margins(0),
				showcaseMargins = margins(0)
			}
					)
end

sysgraph:setup()
