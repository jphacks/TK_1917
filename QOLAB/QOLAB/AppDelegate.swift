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
    var isStopped = false
    var count = 1
    static var keyCount = 0
    static var appName = ""
    /* タイマー変数 */
    var timer = Timer()
    
    override init(){
        print("Appdelegete init!!")
    }
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
        
        let storyboard = NSStoryboard.init(name: "Auth", bundle: nil)
        let loginViewController = storyboard.instantiateController(withIdentifier: "login")
        let registerViewController = storyboard.instantiateController(withIdentifier: "register")
        loginPopOver.contentViewController = (loginViewController as! NSViewController)
        registerPopOver.contentViewController = (registerViewController as! NSViewController)
        
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
        /* タイマー実行 */
        self.timer = Timer.scheduledTimer(
                    timeInterval: 3,//実行する時間
                    target: self,
                    selector: #selector(self.CountDown),//実行関数
                    userInfo: nil,
                    repeats: true
        )
//        RunLoop.current.run()
        let d = Keylogger()
        OperationQueue().addOperation({ () -> Void in
    
            while(!self.isStopped) {
                d.start()
            }

        })
        print("d start")
    }
    
    /* タイマー関数 */
    @objc func CountDown() {
        self.count += 1
        print("count:", count)
        self.logger_start()
//        /* 10秒かカウントしたらタイマーストップ */
//        if (self.count > 10) {
//            timer.invalidate()
//        }
    }
    
    @objc func keyCountUp(key: String) {
        print("keyCountUp:", key, AppDelegate.keyCount)
        AppDelegate.keyCount += 1
    }
    
    @objc func logger_start() {
        print("logger_start")
        print(AppDelegate.appName, AppDelegate.keyCount)
    }
    
    @objc func stop() {
        self.isStopped = true
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

struct PlaygroundStr: Codable {
    let _id: String
    let name: String
    let createdAt: String
    let __v: Int
}
