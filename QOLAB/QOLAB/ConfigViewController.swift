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
    var appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sittingThreshold: NSTextField!
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        print("savebutton clicked!!!", sittingThreshold.stringValue)
        appDelegate.closeConfigPopover(sender)
        appDelegate.initStatusBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {}
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func closePopOver(_ sender: Any) {
        appDelegate.closeConfigPopover(sender)
        appDelegate.initStatusBar()
    }
}
