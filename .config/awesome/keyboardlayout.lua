kbdlayouts = {}

kbdlayouts["English"] = "us"
kbdlayouts["Slovak"] = "sk qwerty"
kbdlayouts["German"] = "de qwerty"

currentKbdLayout = "English"

awful.spawn.with_shell("setxkbmap " .. kbdlayouts[currentKbdLayout])

function nextKbdLayout()
  local keys = gears.table.keys(kbdlayouts)
  local next = 1
  for i = 1, #keys do
    if keys[i] == currentKbdLayout then
      next = i + 1
    end
  end
  if next > #keys then
    next = 1
  end
  currentKbdLayout = keys[next]
  awful.spawn.with_shell("setxkbmap " .. kbdlayouts[currentKbdLayout])
	keyboardindicator:update()
end
--ßß==
