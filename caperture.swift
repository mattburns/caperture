#!/usr/bin/env xcrun swift
import Foundation

// Start QuickTime Player using AppleScript
func startQT() {
    var scriptToPerform: NSAppleScript?
    let asCommand = "tell application \"QuickTime Player\" \n" +
            " activate \n" +
            " new screen recording \n" +
            " delay 1 \n" +
            " tell application \"System Events\" to key code 49 \n" +
            " delay 1\n" +
            " end tell"

    scriptToPerform = NSAppleScript(source:asCommand)
    var possibleError: NSDictionary?

    if let script = scriptToPerform {
        script.executeAndReturnError(&possibleError)
        if let error = possibleError {
            print("ERROR: \(error)")
        }
    }
}

// Click and drag the mouse as defined by the supplied commandline arguments
func dragMouse() {
    let args = UserDefaults.standard

    let x = CGFloat(args.integer(forKey: "x"))
    let y = CGFloat(args.integer(forKey: "y"))
    let w = CGFloat(args.integer(forKey: "w"))
    let h = CGFloat(args.integer(forKey: "h"))

    let p0 = NSPointToCGPoint(NSMakePoint(x, y))
    let p1 = NSPointToCGPoint(NSMakePoint(x + w, y + h))

    let mouseDown = CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseDown, mouseCursorPosition: p0, mouseButton: CGMouseButton.left)!
    let mouseDrag = CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseDragged, mouseCursorPosition: p1, mouseButton: CGMouseButton.left)!
    let mouseUp = CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseUp, mouseCursorPosition: p1, mouseButton: CGMouseButton.left)!

    let kDelayUSec : useconds_t = 500_000

    mouseDown.post(tap: CGEventTapLocation.cghidEventTap)
    usleep(kDelayUSec)
    mouseDrag.post(tap: CGEventTapLocation.cghidEventTap)
    usleep(kDelayUSec)
    mouseUp.post(tap: CGEventTapLocation.cghidEventTap)
}


if (CommandLine.arguments.count != 9) {
    print("usage:")
    print("    ./caperture.swift -x 100 -y 100 -w 400 -h 300")
} else {
    startQT()
    dragMouse()
}