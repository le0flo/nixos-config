local terminal = "foot"
local menu = "fuzzel"

local modifier = "SUPER"

hl.bind(modifier .. " + Q", hl.dsp.window.close())
hl.bind(modifier .. " + SHIFT + E", hl.dsp.exit())

hl.bind(modifier .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(modifier .. " + P", hl.dsp.exec_cmd(menu))

hl.bind(modifier .. " + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(modifier .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(modifier .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(modifier .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(modifier .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(modifier .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(modifier .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(modifier .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(modifier .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(modifier .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(modifier .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"), { locked = true })
