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
    name = "open-maximized",
    match = { initial_class = "^dev.zed.Zed|librewolf|thunderbird$" },

    scrolling_width = 1,
})

hl.window_rule({
    name = "portals",
    match = { initial_class = "^xdg-desktop-portal-gtk" },

    float = true,
    center = true,
})

hl.window_rule({
    name = "hidden-apps",
    match = { initial_class = "^org.keepassxc.KeePassXC|org.telegram.desktop|thunderbird$" },

    no_screen_share = true,
})

hl.layer_rule({
    name = "hidden-layer",
    match = { namespace = "notifications" },

    no_screen_share = true,
})
