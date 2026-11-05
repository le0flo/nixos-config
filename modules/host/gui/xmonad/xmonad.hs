import XMonad
import XMonad.Util.EZConfig
import System.Exit (exitWith, ExitCode(ExitSuccess))

main :: IO ()
main = xmonad $ def
  { modMask = mod4Mask
  }
  `additionalKeysP`
  [ ("M-<Return>", spawn "urxvt")
  , ("M-q", kill)
  , ("M-m", io (exitWith ExitSuccess))
  ]
