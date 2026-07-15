---
name: set-up-mac
description: Install Kerrick's standard macOS applications and apply his preferred system customizations. Use when setting up a new Mac, auditing an existing Mac against the standard setup, installing one or more standard applications, or restoring the preferred Dock, keyboard, menu bar, clock, and modifier-key behavior.
---

# Set Up Mac

Bring the Mac to the desired end state. Adapt the implementation to the installed macOS version and available management tools; do not assume a specific package manager or defaults command is the best route.

## Workflow

1. Inventory the requested applications and settings. Do not reinstall or overwrite items already in the desired state.
2. For each missing application, try installation sources in this order:
   1. Self Service, if available.
   2. Mac App Store.
   3. Homebrew
   4. Official vendor installation instructions found on the internet.
3. Before following internet installation instructions, show the user the official source and intended action, then obtain approval for that application. Ask separately for every application; approval for one does not cover another. Do not use third-party download mirrors. You do not need to ask approval for Self Service or for Mac App Store or for Homebrew.
4. Apply the requested customizations using mechanisms appropriate to the OS version. Preserve unrelated preferences.
5. Verify each application launches or reports a valid installed version, and read back each setting where possible. Report anything requiring user authentication, a restart, logout, permission grant, or manual action.

## Applications

- Homebrew
- MonitorControl
- Ice
- iTerm2
- Rectangle
- Amphetamine
- Tailscale
- MeetingBar
- Visual Studio Code
- Codex (GUI app)

## Customizations

- Automatically hide the Dock.
- Require hovering at the bottom of the screen for about five seconds before the hidden Dock appears.
- Set keyboard repeat to the fastest intended configuration. The known target values on supported macOS versions are `InitialKeyRepeat = 15` and `KeyRepeat = 2`; verify effective behavior rather than assuming the keys are honored.
- Configure Visual Studio Code so holding a letter key repeats it instead of opening the accented-character picker.
- Hide the individual Bluetooth, Spotlight, and display brightness items from the top-right menu bar. Do not disable the underlying features.
- Show the menu bar clock in 24-hour format.
- Remap Caps Lock to Escape.
- Disable **Force Click and haptic feedback** for the trackpad. Verify the effective System Settings control is off.
- Save screenshots in `~/Documents/Screenshots`.

## Confirmed macOS 26 Methods

These commands were confirmed by Kerrick to produce the intended behavior on macOS 26. Do not replace them with inferred alternatives unless they stop working.

### Dock

```sh
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 5
killall Dock
```

### Visual Studio Code key repeat

```sh
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

Restart Visual Studio Code after changing this preference.

### Caps Lock to Escape

For the built-in keyboard (`VendorID = 0`, `ProductID = 0`), persist the mapping and activate it immediately:

```sh
defaults -currentHost write -g \
  'com.apple.keyboard.modifiermapping.0-0-0' \
  -array \
  '{ HIDKeyboardModifierMappingDst = 30064771113; HIDKeyboardModifierMappingSrc = 30064771129; }'

hidutil property --set \
  '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":30064771129,"HIDKeyboardModifierMappingDst":30064771113}]}'
```

Use the actual vendor and product IDs for a different keyboard. Verify by pressing Caps Lock, because `hidutil property --get UserKeyMapping` may report `null` on macOS 26 even when the mapping works.

### Screenshot location

```sh
mkdir -p ~/Documents/Screenshots
defaults write com.apple.screencapture location ~/Documents/Screenshots
killall SystemUIServer
```

Verify with `defaults read com.apple.screencapture location` and confirm it reports `/Users/kerrick/Documents/Screenshots`.

## Confirmed macOS 26 GUI Methods

Use native System Settings controls for the following settings. The corresponding `defaults` writes did not control the effective state on macOS 26. System Events accessibility automation requires Accessibility permission.

Open panes with `open`, then discover controls by accessibility description, name, or identifier. Do not rely on numeric child positions because the hierarchy can change. If System Settings has stale navigation state, quit it and reopen the desired pane.

### Keyboard repeat

```sh
open 'x-apple.systempreferences:com.apple.Keyboard-Settings.extension'
```

In the Keyboard pane:

1. Find the `AXSlider` whose `AXDescription` is `Key repeat rate`.
2. Perform its `AXIncrement` action until `AXValue` equals `AXMaxValue`.
3. Find the `AXSlider` whose `AXDescription` is `Delay until repeat`.
4. Perform its `AXIncrement` action until `AXValue` equals `AXMaxValue`. The rightmost position is the shortest delay.
5. Read both sliders back. The confirmed maximum values were `7` for repeat rate and `6` for delay until repeat.

### Spotlight, Bluetooth, and Display menu bar items

```sh
open 'x-apple.systempreferences:com.apple.ControlCenter-Settings.extension'
```

The pane is titled **Menu Bar** on macOS 26. Find `AXCheckBox` controls by these `AXIdentifier` values:

- Spotlight: `controlcenter-spotlight-id`
- Bluetooth: `controlcenter-bluetooth-id`
- Display: `controlcenter-display-id`

For each checkbox, perform `AXPress` when `AXValue` is nonzero. Verify all three values are `0`. If a checkbox reports `0` but its item remains visible, press it once to turn it on, then press it again to force a native off-state commit.

### 24-hour clock

Use Date & Time, not the Clock Options sheet or Language & Region:

```sh
open 'x-apple.systempreferences:com.apple.Date-Time-Settings.extension'
```

Find the `AXCheckBox` named `24-hour time`. Perform `AXPress` if its value is `0`, then verify its value is `1`. Also verify the Date and time preview uses a value such as `17:39` with no AM/PM marker.

## Execution Rules

- Support both a full setup and a requested subset.
- Prefer reversible, OS-supported configuration paths.
- Do not silently broaden the setup beyond this list.
- Do not claim success based only on a command's exit status; confirm the resulting state.
- If the current OS no longer exposes a requested behavior, explain the closest supported equivalent and ask before substituting it.
