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
    var errorInfo = AutoreleasingUnsafeMutablePointer<NSDictionary?>()

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
 
    let mouseDown = CGEventCreateMouseEvent(nil, CGEventType(kCGEventLeftMouseDown), p0, CGMouseButton(kCGMouseButtonLeft)).takeUnretainedValue()
    let mouseDrag = CGEventCreateMouseEvent(nil, CGEventType(kCGEventLeftMouseDragged), p1, CGMouseButton(kCGMouseButtonLeft)).takeUnretainedValue()
    let mouseUp = CGEventCreateMouseEvent(nil, CGEventType(kCGEventLeftMouseUp), p1, CGMouseButton(kCGMouseButtonLeft)).takeUnretainedValue()
 
    let kDelayUSec : useconds_t = 500_000
    
    CGEventPost(CGEventTapLocation(kCGHIDEventTap), mouseDown)
    usleep(kDelayUSec)
    CGEventPost(CGEventTapLocation(kCGHIDEventTap), mouseDrag)
    usleep(kDelayUSec)
    CGEventPost(CGEventTapLocation(kCGHIDEventTap), mouseUp)
}

 
if (Process.arguments.count != 9) {
    println("usage:")
    println("    ./caperture.swift -x 100 -y 100 -w 400 -h 300")
} else {
    startQT()
    dragMouse()
}

