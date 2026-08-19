---
name: set-up-mac
description: Install Kerrick's standard macOS applications and apply his preferred system customizations. Use when setting up a new Mac, auditing an existing Mac against the standard setup, installing one or more standard applications, or restoring the preferred Dock, keyboard, menu bar, clock, and modifier-key behavior.
---

# Set Up Mac

Bring the Mac to the desired end state. Use Homebrew for every application or tool it can install, and adapt configuration methods to the installed macOS version and available management tools.

## Workflow

1. Inventory the requested applications and settings. Do not reinstall or overwrite items already in the desired state.
2. Install every application available through Homebrew with Homebrew. For applications unavailable there, try Self Service, then the Mac App Store, then official vendor installation instructions found on the internet.
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

## Homebrew packages

Install all available command-line tools and applications with Homebrew:

```sh
brew install coreutils fd direnv git jq ripgrep jsonnet node python uv gh tmux watch worktrunk
brew install --cask monitorcontrol jordanbaird-ice iterm2 rectangle tailscale-app meetingbar visual-studio-code codex-app
```

Use the Mac App Store or Self Service for Amphetamine, which has no Homebrew cask. The `codex-app` cask installs the GUI app; `codex` installs the terminal CLI.

## Customizations

- Automatically hide the Dock.
- Require hovering at the bottom of the screen for about five seconds before the hidden Dock appears.
- Disable bouncing Dock icons when applications request attention.
- Set keyboard repeat to the fastest intended configuration. The known target values on supported macOS versions are `InitialKeyRepeat = 15` and `KeyRepeat = 2`; verify effective behavior rather than assuming the keys are honored.
- Configure Visual Studio Code so holding a letter key repeats it instead of opening the accented-character picker.
- Configure Ice to show only the meeting indicator, Wi-Fi, battery, Control Center, and clock, in that order; hide every other menu bar item.
- Hide the individual Bluetooth, Spotlight, and display brightness items from the top-right menu bar. Do not disable the underlying features.
- Exclude `~/code` and `~/src` from Spotlight searches; add each distinct resolved directory only once.
- Show the menu bar clock in 24-hour format.
- Start MeetingBar, Rectangle, and MonitorControl automatically at login.
- Remap Caps Lock to Escape.
- Disable **Force Click and haptic feedback** for the trackpad. Verify the effective System Settings control is off.
- Save screenshots in `~/Documents/Screenshots`.
- In iTerm2, add `:` to **Settings → General → Selection → Characters considered part of a word**.
- Create the **Slack thread to Codex** shortcut and bind it to **⌘⌥⌃S**.

## Confirmed macOS 26 Methods

These commands were confirmed by Kerrick to produce the intended behavior on macOS 26. Do not replace them with inferred alternatives unless they stop working.

### Dock

```sh
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 5
defaults write com.apple.dock no-bouncing -bool true
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

Verify with `defaults read com.apple.screencapture location` and confirm it reports `$HOME/Documents/Screenshots`.

## Confirmed macOS 26 GUI Methods

Use native System Settings controls for the following settings. The corresponding `defaults` writes did not control the effective state on macOS 26. System Events accessibility automation requires Accessibility permission.

Open panes with `open`, then discover controls by accessibility description, name, or identifier. Do not rely on numeric child positions because the hierarchy can change. If System Settings has stale navigation state, quit it and reopen the desired pane.

### Ice menu bar layout

In **Ice → Menu Bar Layout**, arrange the **Visible** section from left to right:

1. MeetingBar.
2. Wi-Fi.
3. Battery.
4. Control Center.
5. Clock.

Move every other item to **Hidden**, including app icons, Bluetooth, Spotlight, and display brightness. Preserve the order of the five visible items.

### Login items

Enable **Launch at Login** or **Start at Login** in each installed application's settings, or add the applications in **System Settings → General → Login Items**:

- MeetingBar.
- Rectangle.
- MonitorControl.

Verify each application is enabled as a login item; do not infer login behavior from the application merely running.

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

### Spotlight search exclusions

Exclude `~/code` and `~/src` through **System Settings → Spotlight → Search Privacy**.

1. Identify which directories exist and whether they resolve to the same location:

```sh
ls -ld ~/code ~/src
realpath ~/code ~/src
```

2. Open the Spotlight settings pane:

```sh
open "x-apple.systempreferences:com.apple.Spotlight-Settings.extension"
```

3. Select **Search Privacy…**, add each distinct resolved directory, and select **Done**. If `~/src` is a symlink to `~/code`, add only the real `~/code` directory; the exclusion covers both paths. If they are separate directories, add both.
4. Reopen **Search Privacy…** and verify every distinct resolved directory is listed.

There is no supported per-directory CLI for changing the Search Privacy exclusion list. `mdutil` controls whole mounted volumes: do not run `mdutil -i off ~/code` or `mdutil -i off ~/src`, because this can disable indexing for the entire containing volume. Do not substitute undocumented marker files, directory renames, or direct preference writes for the verified GUI setting.

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

### iTerm2 word selection

Prefer the CLI. The preference key is `WordCharacters` in `com.googlecode.iterm2`. For Kerrick's confirmed existing character set, append `:` with:

```sh
defaults write com.googlecode.iterm2 WordCharacters '/-+\~_.:'
```

Verify the raw plist value, which should contain one literal backslash:

```sh
plutil -extract WordCharacters raw ~/Library/Preferences/com.googlecode.iterm2.plist
```

The confirmed output is `/-+\~_.:`. `defaults read com.googlecode.iterm2 WordCharacters` displays that single backslash as `\\`, so do not mistake its escaped display for two stored backslashes.

If the existing value differs, preserve its characters and append `:` rather than overwriting it with the confirmed value. If the CLI method is unavailable, open **iTerm2 → Settings → General → Selection** and add `:` to **Characters considered part of a word**. This makes double-click selection include colon-delimited text such as URLs and host/port pairs. Verify the field contains `:`.

### Slack thread to Codex shortcut

Create a shortcut named **Slack thread to Codex** with one **Run Shell Script** action:

```sh
/usr/bin/osascript "$HOME/.applescripts/slack-thread-to-codex.applescript"
```

In the shortcut's details, select **Add Keyboard Shortcut** and press **⌘⌥⌃S**. If scripting is disabled, ask before enabling **Shortcuts → Settings → Advanced → Allow Running Scripts**. Slack needs permission under **System Settings → Privacy & Security → Accessibility**; tell the user to grant Slack access if it is missing. Report any other required permissions. If the AppleScript is not already present, download it from https://github.com/kerrickstaley/homedir.

## Execution Rules

- Support both a full setup and a requested subset.
- Prefer reversible, OS-supported configuration paths.
- Do not silently broaden the setup beyond this list.
- Do not claim success based only on a command's exit status; confirm the resulting state.
- If the current OS no longer exposes a requested behavior, explain the closest supported equivalent and ask before substituting it.
