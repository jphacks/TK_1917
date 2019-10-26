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
    let loginPopOver = NSPopover()
    let registerPopOver = NSPopover()
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
            action: #selector(AppDelegate.toggleRegisterPopover(_:)),
            keyEquivalent: "")

        statusBarMenu.addItem(
            withTitle: "ログイン",
            action: #selector(AppDelegate.toggleLoginPopover(_:)),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "終了",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "q")
        statusBarMenu.addItem(
            withTitle: "計測開始",
            action: #selector(AppDelegate.start),
            keyEquivalent: "s")
        statusBarMenu.addItem(
            withTitle: "計測停止",
            action: #selector(AppDelegate.stop),
            keyEquivalent: "s")
        
        loginPopOver.contentViewController = ViewController(nibName: "LoginViewController", bundle: nil)
        registerPopOver.contentViewController = ViewController(nibName: "RegisterViewController", bundle: nil)
        
    }
    
    @objc func toggleLoginPopover(_ sender: Any){
        if loginPopOver.isShown{
            closeLoginPopover(sender)
        }else{
            closeRegisterPopover(sender)
            showLoginPopover(sender)
        }
    }
    
    @objc func toggleRegisterPopover(_ sender: Any){
        if registerPopOver.isShown{
            closeRegisterPopover(sender)
        }else{
            closeLoginPopover(sender)
            showRegisterPopover(sender)
        }
    }
    
    func showRegisterPopover(_ sender: Any){
        if let button = statusBarItem.button{
            registerPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closeRegisterPopover(_ sender: Any){
        registerPopOver.performClose(sender)
    }
    
    func showLoginPopover(_ sender: Any){
        if let button = statusBarItem.button{
            loginPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closeLoginPopover(_ sender: Any){
        loginPopOver.performClose(sender)
    }
    
    @objc func register () {
        
    }
    
    @objc func start () {

//        RunLoop.current.run()
        OperationQueue().addOperation({ () -> Void in
            let d = Keylogger()
            while(true) {
                d.start()
            }

        })
        print("d start")
    }
    
    @objc func stop() {
        let d = Keylogger()
        d.stop()
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

