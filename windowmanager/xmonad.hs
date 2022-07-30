import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import Data.Monoid
import System.Exit
import XMonad.Layout.Spacing
import Control.Concurrent
import XMonad.Actions.SpawnOn
import XMonad.Util.SpawnOnce (spawnOnOnce)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myVolStep = "5" -- My volume step.

-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_t), spawn $ XMonad.terminal conf)

    , ((modm,               xK_s     ), spawn "dmenu_run -nb '#000000'  -sf '#1e1e1e'  -sb '#00f000'  -nf '#00f000' ")

    -- close focused window
--    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm .|. shiftMask, xK_t     ), kill)

     -- Rotate through the available layout algorithms
--    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm,               xK_y ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
--    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm .|. shiftMask, xK_y ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_o     ), refresh)  -- TODO what is this?

    -- Move focus to the next window
    , ((modm,               xK_n     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_e     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window with the next window
--    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_n     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_e     ), windows W.swapUp    )

    -- Shrink the master area
--    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Shrink)

    -- Expand the master area
--    , ((modm,               xK_i     ), sendMessage Expand)
    , ((modm,               xK_u     ), sendMessage Expand)

    -- Open text editor popup
    , ((modm,               xK_x     ), spawn "popup_editor.sh")

    -- Screencap part of the screen
    , ((modm,               xK_c     ), spawn "flameshot gui")

    -- Push window back into tiling
    , ((modm,               xK_v     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
--    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_p ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
--    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm              , xK_g), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
--    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
--    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- My own keybindings.
    -- Fn+F3
    , ((0                 , 0x1008FF06), spawn "toggle-kecomp.sh")
    -- Fn+F4
    , ((0                 , 0x1008FF05), spawn "toggle-backlight.sh")
    -- Fn+F5: Brightness down (make sure my user is in the `video` group, then logout/login)
    , ((0                 , 0x1008FF03), spawn "light -S 1")
    -- Fn+F6: Brightness up (make sure my user is in the `video` group, then logout/login)
    , ((0                 , 0x1008FF02), spawn "light -S 100")
    -- Fn+F9: Enable/disable touchpad
    , ((0                 , 0x1008FFA9), spawn "touchpad-toggle.sh")
    -- Fn+F10: Toggle between Mute and non-mute
    , ((0                 , 0x1008FF12), spawn "amixer set Master toggle")
    -- Fn+F11: Lower volume by <myVolStep> Db
    , ((0                 , 0x1008FF11), spawn ("amixer set Master " ++ myVolStep ++ "%- > /dev/null"))
    -- Fn+F12: Raise volume by <myVolStep> Db
    , ((0                 , 0x1008FF13), spawn ("amixer set Master " ++ myVolStep ++ "%+ > /dev/null"))
    -- Print screen
    , ((0                 , xK_Print), spawn "scrot -e 'mv $f ~/pictures/scrot/'")
    -- Toggle keyboard layout (xK_section = button left of "1")
    , ((0                 , xK_section), spawn "/home/sebelino/bin/toggle_solemak.sh")
    -- Secret.wav
    , ((modm              , xK_Pause), spawn "mplayer ~/music/Secret.wav -af volume=10:1")
    -- Lock screen
    , ((modm              , xK_0), spawn "xscreensaver-command -lock")

    -- Create Jira ticket
    , ((modm              , xK_End), spawn "~/bin/create_issue.sh")

    --, ((modm              , xK_Aring), spawn "touch /tmp/HOY_Aring.txt")
    --, ((modm              , xK_Page_Up), spawn "touch /tmp/HOY_PageUp.txt")
    --, ((modm              , xK_Page_Down), spawn "touch /tmp/HOY_PageDown.txt")
    --, ((modm              , xK_space), spawn "touch /tmp/HOY_Space.txt")

    -- For crappy USB mice
    , ((modm              , xK_j), spawn "sudo ~/scripts/usbmouse-stop-idling.sh")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_a, xK_q, xK_w] [0..]  --SEBELINO
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = tiled ||| Mirror tiled ||| Full --SEBELINO
myLayout = tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 5/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = manageSpawn <+> composeAll  -- Needs "manageSpawn <+>" for spawnOn to work
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , appName   =? "center_window"  --> doRectFloat (W.RationalRect 0.2 0.2 0.6 0.6)
    ]

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook :: X()
myStartupHook = do --SEBELINO
    setWMName "LG3D"
    spawnOnOnce "1" "urxvt"
    spawnOnOnce "2" "chromium"
    spawnOnOnce "4" "solaar"
    spawnOnOnce "4" "pavucontrol"
    spawnOnOnce "5" "thunderbird"
    spawnOnOnce "5" "slack"
    spawnOnOnce "6" "chromium -app=https://docs.google.com/spreadsheets/d/1XqVApGZCqDE5orAhljFu2T9_SmQCgszvfd3y2HsW0Dk/edit#gid=1328184427"
    spawnOnOnce "9" "urxvt -e cmus"
    spawnOnOnce "9" "urxvt -cd ~/vita"

spawnToWorkspace :: String -> String -> X()
spawnToWorkspace workspace app = do
    spawn app
    windows $ W.greedyView workspace
--    windows $ W.greedyView workspace
--    spawnHere app

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad def {
      -- simple stuff
        terminal           = "urxvt",
        focusFollowsMouse  = False,                  -- Whether focus follows the mouse pointer.
        clickJustFocuses   = True,                   -- Whether clicking on a window to focus also passes the click to the window
        borderWidth        = 1,
        modMask            = mod4Mask, -- mod1Mask = Alt key, mod4Mask = Hyper_L. Do "xkbcomp $DISPLAY"
        workspaces         = ["1","2","3","4","5","6","7","8","9"],
        normalBorderColor  = "#111111",
        focusedBorderColor = "#600000",

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = mconcat [ docksEventHook, handleEventHook defaultConfig ],
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
