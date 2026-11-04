hl.config({
      misc = {
         force_default_wallpaper = 0,
         disable_hyprland_logo = true,
         disable_splash_rendering = true,
      },

      general = {
         resize_on_border = false,
         allow_tearing = false,

         gaps_in = 2,
         gaps_out = 4,

         layout = "scrolling",
         border_size = 1,

         col = {
            active_border = "rgba(ff0000ff)",
            inactive_border = "rgba(dadadaff)",
         }
      },

      decoration = {
         rounding = 0,
         rounding_power = 1,

         active_opacity = 1.0,
         inactive_opacity = 1.0,
      },

      animations = { enabled = false },

      scrolling = {
         fullscreen_on_one_column = false,
         wrap_focus = false,
         wrap_swapcol = false,
      },
})
