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

## Execution Rules

- Support both a full setup and a requested subset.
- Prefer reversible, OS-supported configuration paths.
- Do not silently broaden the setup beyond this list.
- Do not claim success based only on a command's exit status; confirm the resulting state.
- If the current OS no longer exposes a requested behavior, explain the closest supported equivalent and ask before substituting it.
