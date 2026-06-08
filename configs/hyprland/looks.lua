local ok, colors = pcall(require, "colors")
colors = ok and colors or {
    border_active = "#33ccff",
    border_inactive = "#595959",
}

hl.config({
    general = {
        gaps_in = 8,
        gaps_out = 16,

        border_size = 2,

        col = {
            active_border = colors.border_active,
            inactive_border = colors.border_inactive,
        },

        resize_on_border = false,
        allow_tearing = false,

        layout = "scrolling",
    },

    decoration = {
        rounding = 0,
        shadow = { enabled = false },
        blur = { enabled = false },
    },

    animations = {
        enabled = true,
    },

    scrolling = {
        fullscreen_on_one_column = false,
    },
})

hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "windows", enabled = true, speed = 0.5, spring = "easy", style = "popin" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, spring = "easy", style = "slidevert" })
hl.animation({ leaf = "layers", enabled = true, speed = 0.5, bezier = "quick", style = "fade" })
