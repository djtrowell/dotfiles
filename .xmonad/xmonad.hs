-- Imports
-- Base
import XMonad hiding ((|||))
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.Promote

--Hooks
import XMonad.Hooks.ManageDocks

-- Layout modifiers
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing

-- Layouts
import XMonad.Layout.Grid
import XMonad.Layout.MultiColumns
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spiral

-- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad


-- Settings
-- Defaults
myTerminal = "xterm"
myBrowser  = "firefox"
myEditor   = myTerminal ++ "-e vim"

-- Configuration
myBorderWidth = 1
myNormalColor = "#282C34"
myFocusColor  = "#9DADCC"
myModMask     = mod4Mask

-- Window Spacing Configuration
mySpacing  :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border  0 i 0 i) True (Border i 0 i 0) True


-- Scratchpad Configuration
-- Size Configuration
dw = 0.8 -- The default width of a scratchpad
dh = 0.8 -- The default height of a scratchpad

-- Initialisation
myScratchpads :: [NamedScratchpad]
myScratchpads  = [ NS "pulsemixer" spawnPMix findPMix managePMix
                 , NS "alsamixer"  spawnAlsa findAlsa manageAlsa
                 , NS "spotifytui" spawnSpot findSpot manageSpot
                 , NS "terminal"   spawnTerm findTerm manageTerm
                 , NS "calc"       spawnCalc findCalc manageCalc
                 , NS "htop"       spawnHtop findHtop manageHtop
                 ]
  where
    -- Run Configuration
    spawnPMix  = myTerminal ++ " -class pulsemixerSP -e pulsemixer"
    spawnAlsa  = myTerminal ++ " -T alsamixer[sp] -e alsamixer"
    spawnSpot  = myTerminal ++ " -T spotifytui[sp] -e spt"
    spawnTerm  = myTerminal ++ " -class termSP"
    spawnCalc  = myTerminal ++ " -T calc[sp] -e calc"
    spawnHtop  = myTerminal ++ " -T htop[sp] -e htop"

    -- Name Configuration
    findPMix   = className =? "pulsemixerSP"
    findAlsa   = title     =? "alsamixer[sp]"
    findSpot   = title     =? "spotifytui[sp]"
    findTerm   = className =? "termSP"
    findCalc   = title     =? "calc[sp]"
    findHtop   = title     =? "htop[sp]"

    -- Window Configuration
    managePMix = customFloating $ W.RationalRect ((1 - dw) / 2) ((1 - dh) / 2) dw dh
    manageAlsa = customFloating $ W.RationalRect ((1 - dw) / 2) ((1 - dh) / 2) dw dh
    manageSpot = customFloating $ W.RationalRect ((1 - dw) / 2) ((1 - dh) / 2) dw dh
    manageTerm = customFloating $ W.RationalRect ((1 - dw) / 2) ((1 - dh) / 2) dw dh
    manageCalc = customFloating $ W.RationalRect ((1 - dw) / 2) ((1 - dh) / 2) dw dh
    manageHtop = customFloating $ W.RationalRect ((1 - dw) / 2) ((1 - dh) / 2) dw dh


-- Manage Hook Configuration
myManageHook = composeAll
    [ className =? "Eclipse IDE"    --> doFloat
    ] <+> namedScratchpadManageHook myScratchpads


-- Layout Configuration
-- Defaults
wSpacing = 4      -- The amount of spacing between windows to be used by default
nmaster  = 1      -- The number of windows in the master pane
ratio    = 1/2    -- The default size of the master pane
delta    = 3/100  -- The amount of the screen to increment when resizing panes
spiralR  = 6/7    -- The ratio between successive windows in the spiral layout
nmcolw   = 1      -- The number of windows in each column in the multi-column layout
nmcolms  = (-0.5) -- The size of the master area in multi-column layout (-0.5 for equal)

-- Layouts
fullscreen   = renamed [Replace "fullscreen"]
             $ Full
tall         = renamed [Replace "tall"]
             $ mySpacing wSpacing
             $ Tall nmaster delta ratio
threeColumn  = renamed [Replace "threeColumns"]
             $ mySpacing wSpacing
             $ ThreeCol nmaster delta ratio
grid         = renamed [Replace "grid"]
             $ mySpacing wSpacing
             $ Grid
spirals      = renamed [Replace "spiral"]
             $ mySpacing wSpacing
             $ spiral spiralR
multiColumn  = renamed [Replace "multiColumns"]
             $ mySpacing wSpacing
             $ multiCol [nmaster] nmcolw delta nmcolms

myLayoutHook = avoidStruts 
             ( tall
           ||| threeColumn
           ||| grid
           ||| spirals 
           ||| multiColumn)
           ||| noBorders fullscreen


-- Keyboard Configuration
myKeys =
  -- Misc launch
  [ ("M-S-<Enter>", spawn myTerminal)
  , ("M-p"        , spawn "dmenu_run -h 24 -fn 'Misc Fixed:size=8'")
  , ("M-o"        , spawn "picker")
  , ("M-i"        , spawn "site-open")

  -- Window navigation
  , ("M-<Up>",  promote)
  , ("M-<Tab>", sendMessage NextLayout)
  
  -- Scratchpad navigation
  , ("M-C-<F1>",    namedScratchpadAction myScratchpads "pulsemixer")
  , ("M-C-<F7>",    namedScratchpadAction myScratchpads "spotifytui")
  , ("M-C-<F10>",   namedScratchpadAction myScratchpads "terminal")
  , ("M-C-<F11>",   namedScratchpadAction myScratchpads "calc")
  , ("M-C-<F12>",   namedScratchpadAction myScratchpads "htop")
  , ("M-C-S-<F1>",  namedScratchpadAction myScratchpads "alsamixer")

  -- Layout navigation
  , ("M-<Space>", sendMessage $ JumpToLayout "fullscreen")
  , ("M-<F1>",    sendMessage $ JumpToLayout "tall")
  , ("M-<F2>",    sendMessage $ JumpToLayout "threeColumns")
  , ("M-<F3>",    sendMessage $ JumpToLayout "grid")
  , ("M-<F4>",    sendMessage $ JumpToLayout "spiral")
  , ("M-<F5>",    sendMessage $ JumpToLayout "multiColumns")

  -- Screenshot keybindings
  , ("M-<Print>",   spawn "scrot 'IMG_%Y%j%H%M%S.png'     -e 'mv $f ~/media/screenshots/ ; xclip -selection clipboard -target image/png ~/media/screenshots/$n'")
  , ("M-S-<Print>", spawn "scrot 'IMG_%Y%j%H%M%S.png' -s -f -e 'mv $f ~/media/screenshots/ ; xclip -selection clipboard -target image/png ~/media/screenshots/$n'")
  ]


-- Main
main :: IO ()
main = do
  xmonad $ docks def 
    { modMask            = myModMask
    , terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormalColor
    , focusedBorderColor = myFocusColor
    , layoutHook         = myLayoutHook
    , manageHook         = myManageHook
    } `additionalKeysP` myKeys
