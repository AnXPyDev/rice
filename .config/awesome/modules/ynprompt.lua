ynprompt = {}

local ynIcons = {
	yes = materializeSurface(gears.surface.load(PATH.home .. "icons/check.png")),
	no = materializeSurface(gears.surface.load(PATH.home .. "icons/close.png"))
}

function ynprompt.new(args)
	local images = {
		yes = wibox.widget.imagebox(),
		no = wibox.widget.imagebox()
	}

	local function makeUpdateFunction(name)
		return function(i, isSelected)
			if isSelected then
				images[name].image = ynIcons[name].onPrimary
			else
				images[name].image = ynIcons[name].onBackground
			end
		end
	end

	local menu = SearchMenu:new()
		:setup(
			{
				screen = screens.primary,
				wibox = {
					size = {dpi(540), dpi(340)},
					pos = {screens.primary.geometry.x + (screens.primary.geometry.width - dpi(500)) / 2, screens.primary.geometry.y + (screens.primary.geometry.height - dpi(400)) / 2},
				},
				prompt = {
					size = {
						nil, dpi(60)
					},
					halign = "left",
				},
				elements = {
					boundedMargins = margins(dpi(10)),
					size = {
						dpi(100), dpi(120)
					},
					halign = "center",
					valign = "center",
					showcasePosition = "top",
					list = {
						{name = "Yes", showcase = images.yes, update = makeUpdateFunction("yes"), callback = args.yesCallback or nil},
						{name = "No", showcase = images.yes, update = makeUpdateFunction("no"), callback = args.noCallback or nil}
					}
				}
					})
	menu:show()
end

