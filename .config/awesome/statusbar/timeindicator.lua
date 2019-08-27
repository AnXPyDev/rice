-- /timeindicator.lua

--[[
	This file is a part of my (notabug.org/anxpydev) awesomewm configuration.
	Feel free to use anything from this file for your configuration, but be aware that
	this file might depend on other modules from my config.
]]--

timeindicator = {}

-- Initializes time indicator

function timeindicator:setup()
	self.config = {}

	themer.apply(
		{
			{"bg", "#000000"},
			{"fg", "#FFFFFF"},
			{"shape", gears.shape.rectangle},
			{"margins", margins(0)},
			{"halign", "center"},
			{"valign", "center"}
		},
		themeful.timeIndicator or {}, self.config
	)
	
	self.widget = {}

	self.widget.clock = wibox.widget.textclock("%H:%M:%S", 1)
	self.widget.clock.font = "Hack " .. tostring(dpi(20))
	self.widget.date = wibox.widget.textbox()

	-- Creates a string to display as the date e.g. "Sun, 21st Jul 2019"
	
	gears.timer {
		autostart = true,
		call_now = true,
		timeout = 60,
		callback = function()
			local day = os.date("%d")
			local digit = day:sub(-1)
			local suffix = digit == "1" and "st" or digit == "2" and "nd" or digit == "3" and "rd" or "th"
			local number = day:sub(1, 1) == "0" and digit or day
			self.widget.date.text = os.date("%a, " .. number .. suffix .. " %b %Y")
		end
	}

	self.widget.bare = wibox.widget {
		wibox.container.place(self.widget.clock, self.config.halign, self.config.valign),
		wibox.container.place(self.widget.date, self.config.halign, self.config.valign),
		layout = wibox.layout.flex.vertical
	}

	self.widget.margin = wibox.container.margin(self.widget.bare)
	gears.table.crush(self.widget.margin, self.config.margins)

	self.widget.background = wibox.container.background(self.widget.margin, self.config.bg, self.config.shape)
	self.widget.background.fg = self.config.fg

	self.widget.final = self.widget.background

end

timeindicator:setup()
