//
//  LogViewController.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/11/07.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa

class LogViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBAction func closeButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        print("tableView: ", row)
//        return programs[row]
//    }
}

extension LogViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Sensing.appLogList.count
    }
}

extension LogViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let ApplicationNameCell = "ApplicationNameCellID"
        static let DateCell = "DateCellID"
        static let CategoryCell = "CategoryCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//    var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMMHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        // 1
//    guard let item = directoryItems?[row] else {
//      return nil
//    }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = dateFormatter.string(from: Sensing.dateList[row])
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = Sensing.appLogList[row]
            cellIdentifier = CellIdentifiers.ApplicationNameCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = Sensing.categoryLogList[row]
            cellIdentifier = CellIdentifiers.CategoryCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
//      cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
}
