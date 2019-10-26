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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func signIn(_ sender: Any) {
        APIClient.fetchArticle { (articles) in
                   self.articles = articles
                   DispatchQueue.main.sync {
                       print(articles)
                   }
               }
    }
    
    @IBAction func didClickLoginButton(_ sender: Any) {
        print(emailTextField.stringValue)
        print(passTextField.stringValue)
        
        
    }


}
