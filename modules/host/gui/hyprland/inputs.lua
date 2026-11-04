hl.config({
      input = {
         kb_layout  = "it",
         kb_variant = "",
         kb_model   = "",
         kb_options = "",
         kb_rules   = "",

         repeat_delay = 200,
         repeat_rate = 25,

         follow_mouse = 2,
         sensitivity = 0,

         touchpad = { natural_scroll = true },
      },
})

hl.gesture({
      fingers = 3,
      direction = "vertical",
      action = "workspace",
})
