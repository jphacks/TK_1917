//
//  AppDelegate.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Insert code here to initialize your application
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage.init(named: "iconW")
        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu
        statusBarMenu.addItem(
            withTitle: "新規登録",
            action: #selector(AppDelegate.register),
            keyEquivalent: "")

        statusBarMenu.addItem(
            withTitle: "ログイン",
            action: #selector(AppDelegate.login),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "終了",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "q")
        
    }
    
    @objc func register () {
        
    }
    
    @objc func login() {
        
    }
    
    @objc func quit(){
        //アプリケーションの終了
        NSApplication.shared.terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

