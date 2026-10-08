hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    general = {
        resize_on_border = false,
        allow_tearing = false,

        gaps_in = 5,
        gaps_out = 10,

        layout = "scrolling",
        border_size = 2,
    },

    decoration = {
        rounding = 0,
        rounding_power = 0,

        active_opacity = 1.0,
        inactive_opacity = 1.0,
    },

    animations = { enabled = true },

    scrolling = {
       fullscreen_on_one_column = false,
       wrap_focus = false,
       wrap_swapcol = false,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

hl.animation({ leaf = "border", enabled = false })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "global", enabled = false })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "quick", style = "slide" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = false })
