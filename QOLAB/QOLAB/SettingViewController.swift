//
//  SettingViewController.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/11/09.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa
import Foundation

class SettingViewController: NSViewController {
    @IBOutlet var appName: NSTextField!
    @IBOutlet var selector: NSComboBox!
    @IBOutlet var cancelButton: NSButton!
    @IBOutlet var saveButton: NSButton!
    var selectedCategory: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        appName.stringValue = ConfigViewController.appName
        selector.removeAllItems()
        selector.addItem(withObjectValue: "writing")
        selector.addItem(withObjectValue: "break")
        selector.addItem(withObjectValue: "implementation")
        selector.addItem(withObjectValue: "survey")
        selector.selectItem(withObjectValue: ConfigViewController.category)
    }
    
    @IBAction func onClickCancelButton(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func onClickSaveButton(_ sender: NSButton) {
        view.window?.close()
        // FIXME: ドメインとアプリの判定をもっと先にやらせる
        Sensing.categoryLogList[ConfigViewController.idx] = selector.objectValueOfSelectedItem as! String
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("reload"), object: nil)
        
        // 画面を閉じる
        if appName.stringValue.contains(".") {
//            print(categories?.domain[ConfigViewController.category])
            for i in Sensing.categories.domain {
                if let idx = i.value.lastIndex(of: appName.stringValue) {
                    var custom = i.value
                    custom.remove(at: idx)
                    Sensing.categories.domain[i.key] = custom
                }
            }
            Sensing.categories.domain[selector.objectValueOfSelectedItem as! String]?.append(appName.stringValue)
        } else {
            for i in Sensing.categories.app {
                if let idx = i.value.lastIndex(of: appName.stringValue) {
                    var custom = i.value
                    custom.remove(at: idx)
                    Sensing.categories.app[i.key] = custom
                }
            }
            Sensing.categories.app[selector.objectValueOfSelectedItem as! String]?.append(appName.stringValue)
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(Sensing.categories)
            UserDefaults.standard.set(data, forKey: "cat")
        } catch {
            print("heer")
        }
    }
}

// extension SettingViewController: NSComboBoxDelegate {
//    func sele
// }
