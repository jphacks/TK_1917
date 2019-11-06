//
//  LogViewController.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/11/07.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa

class LogViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Sensing.appLogList.count
    }
    
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        print("tableView: ", row)
//        return programs[row]
//    }
    
    func tableView(_ tableView: NSTableView, viewFor
        tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        print(#function + " column:" +
//            tableColumn!.identifier.rawValue + " row:" + String(row))
        var result: NSTextField? =
            tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue:
                "MyView"), owner: self) as? NSTextField
        if result == nil {
            result = NSTextField(frame: NSZeroRect)
            result?.identifier =
                NSUserInterfaceItemIdentifier(rawValue: "MyView")
        }
        if let view = result {
//            print("view:" + view.identifier!.rawValue + " row:" + String(row))
            if let column = tableColumn {
                if column.identifier.rawValue == "applicationNameColumn" {
                    view.stringValue = Sensing.appLogList[row]
                } else if column.identifier.rawValue == "categoryColumn" {
                    view.stringValue = Sensing.categoryLogList[row]
                }
            }
        }
        return result
    }
}
