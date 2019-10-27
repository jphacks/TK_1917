//
//  AppDelegate.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/10/26.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa
import CoreWLAN

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var statusBarItem: NSStatusItem!
    let loginPopOver = NSPopover()
    let joinLabPopOver = NSPopover()
    let sensing = Sensing()
    var isSensingStarted = false
    let NScenter = NSUserNotificationCenter.default

    
    override init(){
        print("Appdelegete init!!")
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let options = NSDictionary(
            object: kCFBooleanTrue,
            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        ) as CFDictionary

        AXIsProcessTrustedWithOptions(options)

        // Insert code here to initialize your application
        initStatusBar()
        
        let storyboard = NSStoryboard.init(name: "Auth", bundle: nil)
        let loginViewController = storyboard.instantiateController(withIdentifier: "login")
        let joinLabViewController = storyboard.instantiateController(withIdentifier: "joinLab")
        loginPopOver.contentViewController = (loginViewController as! NSViewController)
        loginPopOver.behavior = NSPopover.Behavior.transient
        joinLabPopOver.contentViewController = (joinLabViewController as! NSViewController)
        joinLabPopOver.behavior = NSPopover.Behavior.transient
        
    }
    
    func initStatusBar() {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage.init(named: "iconW")
        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        
        statusBarItem.menu = statusBarMenu
        
        let userInfo = UserInfoDao().getUserInfo()
        let labInfo = UserInfoDao().getLabName()
        
        if userInfo == nil {
            statusBarMenu.addItem(
                withTitle: "新規登録",
                action: #selector(AppDelegate.openRegisterPage(_:)),
                keyEquivalent: "s")

            statusBarMenu.addItem(
                withTitle: "ログイン",
                action: #selector(AppDelegate.toggleLoginPopover(_:)),
                keyEquivalent: "l")
        } else {
            if isSensingStarted == true {
                statusBarMenu.addItem(
                    withTitle: "🔵 計測中...",
                    action: nil,
                    keyEquivalent: "")
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "計測停止",
                    action: #selector(AppDelegate.stop),
                    keyEquivalent: "t")
            } else {
                statusBarMenu.addItem(
                    withTitle: "🔴 停止中",
                    action: nil,
                    keyEquivalent: "")
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "計測開始",
                    action: #selector(AppDelegate.start),
                    keyEquivalent: "s")
            }


            if labInfo?.name == nil {
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "ラボに参加",
                    action: #selector(AppDelegate.toggleJoinPopover(_:)),
                    keyEquivalent: "j")
                statusBarMenu.addItem(
                    withTitle: "ログアウト",
                    action: #selector(AppDelegate.logout(_:)),
                    keyEquivalent: "w")
                statusBarMenu.addItem(
                    withTitle: "終了",
                    action: #selector(AppDelegate.quit),
                    keyEquivalent: "q")
            } else {
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "ログアウト",
                    action: #selector(AppDelegate.logout(_:)),
                    keyEquivalent: "w")
                statusBarMenu.addItem(
                    withTitle: "終了",
                    action: #selector(AppDelegate.quit),
                    keyEquivalent: "q")
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: (labInfo!.name+"研究室に参加中"),
                    action: nil,
                    keyEquivalent: "")
                
            }
        }
        

    }
    
    @objc func toggleLoginPopover(_ sender: Any){
        if loginPopOver.isShown{
            closeLoginPopover(sender)
        }else{
            closeJoinPopover(sender)
            showLoginPopover(sender)
        }
    }
    
    @objc func toggleJoinPopover(_ sender: Any) {
        if joinLabPopOver.isShown{
            closeJoinPopover(sender)
        }else{
            showJoinPopover(sender)
            closeLoginPopover(sender)
        }
    }
    
    @objc func openRegisterPage(_ sender: Any){
        NSWorkspace.shared.open(URL(string: "https://qolab-a0324.web.app/signup/")!)
    }
    
    func showLoginPopover(_ sender: Any){
        if let button = statusBarItem.button{
            loginPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func showJoinPopover(_ sender: Any){
        if let button = statusBarItem.button{
            joinLabPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    @objc func logout(_ sender: Any) {
        if self.isSensingStarted {
            stop()
        }
        UserDefaults().removeObject(forKey: UserInfoDao.USER_INFO)
        initStatusBar()
    }

    public func closeLoginPopover(_ sender: Any){
        loginPopOver.performClose(sender)
    }
    
    public func closeJoinPopover(_ sender: Any){
        joinLabPopOver.performClose(sender)
    }
    
    @objc func register () {
        
    }
    
    @objc func start () {
        self.isSensingStarted = true
        initStatusBar()
        self.sensing.start()
        start_notification()
    }
    
    @objc func stop() {
        self.isSensingStarted = false
        initStatusBar()
        self.sensing.stop()
    }
    
    @objc func start_notification() {
        print("start_nortify")
        self.NScenter.delegate = self
        let notification = NSUserNotification.init()
        // アプリ名を表示
        notification.contentImage = NSImage(named: "white")
        notification.title = (Bundle.main.infoDictionary?[kCFBundleNameKey as String])! as? String
        notification.subtitle = "計測を開始しました。"
        self.NScenter.deliver(notification)
        
    }
    
    @objc func login() {
        
    }
    
    
    @objc func quit(){
        self.sensing.quit()
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
