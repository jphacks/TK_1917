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
    
    @IBOutlet weak var sittingTimer: NSTextField!
    @IBOutlet weak var normalTimer: NSTextField!
    @IBOutlet weak var sittingThreshold: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        normalTimer.stringValue = userDefaults.string(forKey: "normalTimer") ?? "60"
        sittingTimer.stringValue = userDefaults.string(forKey: "sittingTimer") ?? "60"
        sittingThreshold.stringValue = userDefaults.string(forKey: "sittingThreshold") ?? "60"
    }
    
    override func viewDidAppear() {}
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        userDefaults.set(normalTimer.stringValue, forKey: "normalTimer")
        userDefaults.set(sittingTimer.stringValue, forKey: "sittingTimer")
        userDefaults.set(sittingThreshold.stringValue, forKey: "sittingThreshold")
        
        appDelegate.closeConfigPopover(sender)
        appDelegate.initStatusBar()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        appDelegate.closeConfigPopover(sender)
        appDelegate.initStatusBar()
    }
}
