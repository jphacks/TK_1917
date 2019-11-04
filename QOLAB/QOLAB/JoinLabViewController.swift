//
//  JoinLabViewController.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa
import Foundation

class JoinLabViewController: NSViewController {
    @IBOutlet var labCode: NSTextField!
    @IBOutlet var joinButton: NSButton!
    @IBOutlet var loadingCircle: NSProgressIndicator!
    @IBOutlet var successText: NSTextField!
    @IBOutlet var closeButton: NSButton!
    @IBOutlet var joinText: NSTextField!
    @IBOutlet var error: NSTextField!
    var appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingCircle.isHidden = true
        closeButton.isHidden = true
        successText.isHidden = true
        error.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        joinText.isHidden = false
        joinButton.isHidden = false
        labCode.isHidden = false
        closeButton.isHidden = true
        loadingCircle.isHidden = true
        successText.isHidden = true
        error.isHidden = true
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func joinLab(_ sender: Any) {
        print(labCode.stringValue)
        loadingCircle.startAnimation(sender)
        error.isHidden = true
        joinButton.isHidden = true
        loadingCircle.isHidden = false
        let paramDto = JoinLabRequest(labCode: labCode.stringValue)
        APIClient.joinLab(joinInfo: paramDto) {
            result in
            DispatchQueue.main.sync {
                self.loadingCircle.isHidden = true
                self.joinButton.isHidden = false
                if result != nil {
                    self.successText.stringValue = result!.name + "に参加しました"
                    self.showJoinSuccess()
                } else {
                    self.error.isHidden = false
                }
                //                print(result)
            }
        }
    }
    
    func showJoinSuccess() {
//        if UserInfoDao().getLabName() != nil {
        appDelegate.observer.start()
//        }
        joinText.isHidden = true
        joinButton.isHidden = true
        labCode.isHidden = true
        closeButton.isHidden = false
        loadingCircle.isHidden = true
        successText.isHidden = false
        error.isHidden = true
    }
    
    @IBAction func closePopOver(_ sender: Any) {
        appDelegate.closeJoinPopover(sender)
        appDelegate.initStatusBar()
    }
}
