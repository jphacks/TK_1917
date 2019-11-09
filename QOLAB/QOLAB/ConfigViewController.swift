//
//  ConfigViewController.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/11/05.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa
import Foundation

class ConfigViewController: NSViewController {
    let userDefaults = UserDefaults.standard
    var appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    static var appName: String = ""
    static var category: String = ""
    static var idx: Int = -1
    static var initialized = false
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var sittingTimer: NSTextField!
    @IBOutlet weak var normalTimer: NSTextField!
    @IBOutlet weak var sittingThreshold: NSTextField!
    @IBOutlet weak var setting: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigViewController.initialized = true
        // Do any additional setup after loading the view.
        normalTimer.stringValue = userDefaults.string(forKey: "normalTimer") ?? "60"
        sittingTimer.stringValue = userDefaults.string(forKey: "sittingTimer") ?? "60"
        sittingThreshold.stringValue = userDefaults.string(forKey: "sittingThreshold") ?? "60"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(update), name: Notification.Name("reload"), object: nil)
    }
    
    override func viewDidDisappear() {
        ConfigViewController.initialized = false
    }
    
    @objc func update() {
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        userDefaults.set(normalTimer.stringValue, forKey: "normalTimer")
        userDefaults.set(sittingTimer.stringValue, forKey: "sittingTimer")
        userDefaults.set(sittingThreshold.stringValue, forKey: "sittingThreshold")
        
        view.window?.close()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func openSettingWindow(_ sender: Any) {
        // 設定画面
        let storyboardName = NSStoryboard.Name(stringLiteral: "Config")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        
        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "Setting")
        if let fontsDisplayWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
            fontsDisplayWindowController.showWindow(nil)
        }
    }
}

extension ConfigViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Sensing.appLogList.count
    }
}

extension ConfigViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let ApplicationNameCell = "ApplicationNameCellID"
        static let DateCell = "DateCellID"
        static let CategoryCell = "CategoryNameCellID"
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        
        if row >= 0 {
            ConfigViewController.appName = Sensing.appLogList[row]
            ConfigViewController.category = Sensing.categoryLogList[row]
            ConfigViewController.idx = row
            setting.isEnabled = true
        } else {
            ConfigViewController.idx = -1
            setting.isEnabled = false
        }
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
            text = Sensing.appLogList[row]
            cellIdentifier = CellIdentifiers.ApplicationNameCell
        } else if tableColumn == tableView.tableColumns[1] {
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
