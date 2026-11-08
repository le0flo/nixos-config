import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig

myConfig = def
  { modMask    = mod4Mask
  , layoutHook = myLayouts
  }
  `additionalKeysP` myBinds

myBinds =
  [ ("M-<Return>", spawn "urxvt")
  , ("M-p",        spawn "dmenu_run")
  , ("M-S-b",      spawn "bg-picker")
  , ("M-S-l",      spawn "slock")
  , ("M-r",        spawn "xmonad --recompile && xmonad --restart")
  , ("M-q",        kill)
  , ("M-m",        io (exitWith ExitSuccess))
  ]

myLayouts = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1
    ratio    = 1/2
    delta    = 3/100

main :: IO ()
main = xmonad . xmobarProp $ myConfig
