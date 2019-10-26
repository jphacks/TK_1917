//
//  LoginViewController.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation
import Cocoa

class LoginViewController: NSViewController {

    var articles: [PlaygroundStr] = []
    @IBOutlet var emailTextField: NSTextField!
    @IBOutlet var passTextField: NSSecureTextField!
    @IBOutlet var loadingCircle: NSProgressIndicator!
    @IBOutlet var loginButton: NSButton!
    @IBOutlet var error: NSTextField!
    @IBOutlet var emailText: NSTextField!
    @IBOutlet var passText: NSTextField!
    @IBOutlet var successText: NSTextField!
    @IBOutlet var successButton: NSButton!
    var appDelegate:AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingCircle.isHidden = true
        error.isHidden = true
        successText.isHidden = true
        successButton.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        passText.isHidden = false
        emailText.isHidden = false
        emailTextField.isHidden = false
        passTextField.isHidden = false
        loginButton.isHidden = false
        error.isHidden = true
        loadingCircle.isHidden = true
        successText.isHidden = true
        successButton.isHidden = true
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func didClickLoginButton(_ sender: Any) {
        loadingCircle.isHidden = false
        loadingCircle.startAnimation(sender)
        loginButton.isHidden = true
        error.isHidden = true
        
        let paramDto = AuthRequest(email: emailTextField.stringValue, password: passTextField.stringValue)
        APIClient.singIn(userInfo: paramDto) {
            (result) in
            DispatchQueue.main.sync {

                if result != nil {
//                    self.showLoginSuccess()
                    APIClient.fetchUserInfo() {
                            (res) in
                            DispatchQueue.main.sync {
                                APIClient.fetchLabInfo() {
                                    (res) in
                                    DispatchQueue.main.sync {
                                        self.showLoginSuccess()
                                    }
                                }
                            }
                        }
                } else {
                    self.error.isHidden = false
                    self.loadingCircle.isHidden = true
                    self.loginButton.isHidden = false
                }
//                print(result)
            }
        }
        
    }
    
    func showLoginSuccess() {
        passText.isHidden = true
        emailText.isHidden = true
        emailTextField.isHidden = true
        passTextField.isHidden = true
        loginButton.isHidden = true
        error.isHidden = true
        loadingCircle.isHidden = true
        successText.isHidden = false
        successButton.isHidden = false
    }
    
    @IBAction func closePopover(_ sender: Any) {
        self.appDelegate.closeLoginPopover(sender)
        self.appDelegate.initStatusBar()
    }


}
