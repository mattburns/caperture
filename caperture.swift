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
    let errorInfo = AutoreleasingUnsafeMutablePointer<NSDictionary?>()

    if let script = scriptToPerform {
        script.executeAndReturnError(errorInfo)
    }
}

// Click and drag the mouse as defined by the supplied commanline arguments
func dragMouse() {
    let args = NSUserDefaults.standardUserDefaults()

    let x  = CGFloat(args.integerForKey("x"))
    let y  = CGFloat(args.integerForKey("y"))
    let w = CGFloat(args.integerForKey("w"))
    let h = CGFloat(args.integerForKey("h"))
 
    let p0 = CGPointMake(x, y)
    let p1 = CGPointMake(x + w, y + h)
 
    let mouseDown = CGEventCreateMouseEvent(nil, CGEventType.LeftMouseDown, p0, CGMouseButton.Left)
    let mouseDrag = CGEventCreateMouseEvent(nil, CGEventType.LeftMouseDragged, p1, CGMouseButton.Left)
    let mouseUp = CGEventCreateMouseEvent(nil, CGEventType.LeftMouseUp, p1, CGMouseButton.Left)
 
    let kDelayUSec : useconds_t = 500_000
    
    CGEventPost(CGEventTapLocation.CGHIDEventTap, mouseDown)
    usleep(kDelayUSec)
    CGEventPost(CGEventTapLocation.CGHIDEventTap, mouseDrag)
    usleep(kDelayUSec)
    CGEventPost(CGEventTapLocation.CGHIDEventTap, mouseUp)
}

 
if (Process.arguments.count != 9) {
    print("usage:")
    print("    ./caperture.swift -x 100 -y 100 -w 400 -h 300")
} else {
    startQT()
    dragMouse()
}

