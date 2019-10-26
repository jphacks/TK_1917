//
//  CustomViewController.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation
import Cocoa

class RegisterViewController: NSViewController {
    var articles: [PlaygroundStr] = []
   @IBOutlet var emailTextField: NSTextField!
   @IBOutlet var passTextField: NSSecureTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSWorkspace.shared.open(URL(string: "https://www.google.com/")!)

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func didClickRegisterButton(_ sender: Any) {
        print(emailTextField.stringValue)
        print(passTextField.stringValue)
        
        
    }



}
