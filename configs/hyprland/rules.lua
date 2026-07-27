-- Monitors
hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60",
  position = "0x0",
  scale = "1.0",
})

hl.monitor({
  output = "DP-6",
  mode = "1920x1080@60",
  position = "-1920x0",
  scale = "1.0",
})

-- Windows
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "fullscreen-programs",
    match = { class = "^Emacs|firefox|thunderbird$" },

    scrolling_width = 1.0,
})

hl.window_rule({
    name = "no-screenshare-programs",
    match = { class = "^org.keepassxc.KeePassXC|thunderbird$" },

    no_screen_share = true,
})

hl.window_rule({
    name = "no-screenshare-browser",
    match = {
       class = "^firefox$",
       title = "work — Mozilla Firefox$",
    },

    no_screen_share = true,
})

-- Layers
hl.layer_rule({
    name = "no-screenshare-layers",
    match = { namespace = "^notifications$" },

    no_screen_share = true,
})
