-- Copies a link to the Slack message that you are hovering over (make sure to hover a blank space and not a word), then starts a new Codex chat and pastes that link so you can ask about it

use framework "AppKit"
use scripting additions

set pasteboard to current application's NSPasteboard's generalPasteboard()
set initialChangeCount to pasteboard's changeCount() as integer

do shell script "/usr/bin/osascript -l JavaScript -e " & quoted form of "ObjC.import('CoreGraphics'); const position = $.CGEventGetLocation($.CGEventCreate(null)); for (const type of [$.kCGEventRightMouseDown, $.kCGEventRightMouseUp]) $.CGEventPost($.kCGHIDEventTap, $.CGEventCreateMouseEvent(null, type, position, $.kCGMouseButtonRight));"

delay 0.25

tell application "System Events"
	keystroke "l"
	repeat 40 times
		if (pasteboard's changeCount() as integer) is not initialChangeCount then exit repeat
		delay 0.05
	end repeat
	if (pasteboard's changeCount() as integer) is initialChangeCount then error "Slack did not copy a link to the clipboard."
	delay 0.25
	set frontmost of (first application process whose bundle identifier starts with "com.openai.codex") to true
	delay 0.25
	keystroke "o" using {command down, option down}
	delay 0.25
	keystroke "v" using command down
	delay 0.25
	keystroke " "
end tell
