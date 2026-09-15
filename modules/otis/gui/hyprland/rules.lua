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
   name = "gtk-dialogs",
   match = { class = "^xdg-desktop-portal-gtk$" },

   float = true,
   center = true,
   size = { "(monitor_w*0.75)", "(monitor_h*0.65)" },
})

hl.window_rule({
   name = "hyprland-dialogs",
   match = { title = "^Select what to share$" },

   float = true,
   center = true,
   size = { "(monitor_w*0.75)", "(monitor_h*0.65)" },
})

hl.window_rule({
   name = "maximized-windows",
   match = { class = "^(firefox|thunderbird|emacs)$"},

   scrolling_width = 1.0,
})

local no_screenshare_window = hl.window_rule({
   name = "no-screenshare-windows",
   match = { class = "^(firefox|thunderbird|org.keepassxc.KeePassXC)$" },

   no_screen_share = true,   
})

local no_screenshare_layer = hl.layer_rule({
   name = "no-screenshare-layers",
   match = { namespace = "^notifications$" },

   no_screen_share = true,
})

hl.bind("SUPER + H", function()
    no_screenshare_window:set_enabled(not no_screenshare_window:is_enabled())
end)

hl.bind("SUPER + SHIFT + H", function()
    no_screenshare_layer:set_enabled(not no_screenshare_layer:is_enabled())
end)

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
