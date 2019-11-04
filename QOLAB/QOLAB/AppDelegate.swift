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
    let configPopOver = NSPopover()
    let sensing = Sensing()
    let observer = MemberObserver()
    var isSensingStarted = false
    let NScenter = NSUserNotificationCenter.default
    var statusBar = NSStatusBar.system
    var statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
    override init() {
        print("Appdelegete init!!")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let options = NSDictionary(
            object: kCFBooleanTrue,
            forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        ) as CFDictionary
        
        AXIsProcessTrustedWithOptions(options)
        
        // Insert code here to initialize your application
        defaultStatusBar()
        initStatusBar()
        
        let authStoryboard = NSStoryboard(name: "Auth", bundle: nil)
        let loginViewController = authStoryboard.instantiateController(withIdentifier: "login")
        let joinLabViewController = authStoryboard.instantiateController(withIdentifier: "joinLab")
        
        loginPopOver.contentViewController = (loginViewController as! NSViewController)
        loginPopOver.behavior = NSPopover.Behavior.transient
        joinLabPopOver.contentViewController = (joinLabViewController as! NSViewController)
        joinLabPopOver.behavior = NSPopover.Behavior.transient
        
        // 設定画面
        let configStoryboard = NSStoryboard(name: "Config", bundle: nil)
        let configViewController = configStoryboard.instantiateController(withIdentifier: "config")
        configPopOver.contentViewController = (configViewController as! NSViewController)
        configPopOver.behavior = NSPopover.Behavior.transient
    }
    
    func defaultStatusBar() {
        statusBar = NSStatusBar.system
        statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength
        )
        
        switch NSApp.effectiveAppearance.name {
        case NSAppearance.Name.darkAqua: // light mode
            statusBarItem.button?.image = NSImage(named: "iconW")
        case NSAppearance.Name.aqua: // dark mode
            statusBarItem.button?.image = NSImage(named: "iconB")
        default: break //the user interface style is not specified
        }
        statusBarItem.menu = statusBarMenu
    }
    
    func initStatusBar() {
        statusBarMenu.removeAllItems()
        let userInfo = UserInfoDao().getUserInfo()
        let labInfo = UserInfoDao().getLabName()
        
        if userInfo == nil {
            statusBarMenu.addItem(
                withTitle: "新規登録",
                action: #selector(AppDelegate.openRegisterPage(_:)),
                keyEquivalent: "s"
            )
            
            statusBarMenu.addItem(
                withTitle: "ログイン",
                action: #selector(AppDelegate.toggleLoginPopover(_:)),
                keyEquivalent: "l"
            )
            statusBarMenu.addItem(
                withTitle: "終了",
                action: #selector(AppDelegate.quit),
                keyEquivalent: "q"
            )
        } else {
            if isSensingStarted == true {
                let item: NSMenuItem = NSMenuItem()
                item.title = " 計測中..."
                item.image = NSImage(named: "blue")
                item.isEnabled = false
                statusBarMenu.addItem(item)
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "計測停止",
                    action: #selector(AppDelegate.stop),
                    keyEquivalent: "t"
                )
            } else {
                let item: NSMenuItem = NSMenuItem()
                item.title = " 停止中"
                item.isEnabled = false
                item.image = NSImage(named: "red")
                statusBarMenu.addItem(item)
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "計測開始",
                    action: #selector(AppDelegate.start),
                    keyEquivalent: "s"
                )
            }
            
            if labInfo?.name == nil {
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "ラボに参加",
                    action: #selector(AppDelegate.toggleJoinPopover(_:)),
                    keyEquivalent: "j"
                )
                statusBarMenu.addItem(
                    withTitle: "ログアウト",
                    action: #selector(AppDelegate.logout(_:)),
                    keyEquivalent: "w"
                )
                statusBarMenu.addItem(
                    withTitle: "終了",
                    action: #selector(AppDelegate.quit),
                    keyEquivalent: "q"
                )
            } else {
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "ログアウト",
                    action: #selector(AppDelegate.logout(_:)),
                    keyEquivalent: "w"
                )
                statusBarMenu.addItem(
                    withTitle: "終了",
                    action: #selector(AppDelegate.quit),
                    keyEquivalent: "q"
                )
                statusBarMenu.addItem(NSMenuItem.separator())
                statusBarMenu.addItem(
                    withTitle: "設定",
                    action: #selector(AppDelegate.toggleConfigPopover(_:)),
                    keyEquivalent: "e"
                )
                
                statusBarMenu.addItem(NSMenuItem.separator())
                let item: NSMenuItem = NSMenuItem()
                item.title = labInfo!.name + "研究室に参加中"
                item.isEnabled = false
                statusBarMenu.addItem(item)
            }
        }
    }
    
    @objc func toggleLoginPopover(_ sender: Any) {
        if loginPopOver.isShown {
            closeLoginPopover(sender)
        } else {
            closeJoinPopover(sender)
            showLoginPopover(sender)
        }
    }
    
    @objc func toggleJoinPopover(_ sender: Any) {
        if joinLabPopOver.isShown {
            closeJoinPopover(sender)
        } else {
            showJoinPopover(sender)
            closeLoginPopover(sender)
        }
    }
    
    @objc func toggleConfigPopover(_ sender: Any) {
        if configPopOver.isShown {
            closeConfigPopover(sender)
        } else {
            showConfigPopover(sender)
        }
    }
    
    @objc func openRegisterPage(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://qolab-a0324.web.app/signup/")!)
    }
    
    func showLoginPopover(_ sender: Any) {
        if let button = statusBarItem.button {
            loginPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func showJoinPopover(_ sender: Any) {
        if let button = statusBarItem.button {
            joinLabPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func showConfigPopover(_ sender: Any) {
        if let button = statusBarItem.button {
            configPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    @objc func logout(_ sender: Any) {
        if isSensingStarted {
            stop()
        }
        UserDefaults().removeObject(forKey: UserInfoDao.USER_INFO)
        initStatusBar()
    }
    
    public func closeLoginPopover(_ sender: Any) {
        loginPopOver.performClose(sender)
    }
    
    public func closeJoinPopover(_ sender: Any) {
        joinLabPopOver.performClose(sender)
    }
    
    public func closeConfigPopover(_ sender: Any) {
        configPopOver.performClose(sender)
    }
    
    @objc func register() {}
    
    @objc func start() {
        isSensingStarted = true
        initStatusBar()
        sensing.start()
        if UserInfoDao().getLabName() != nil {
            observer.start()
        }
        start_notification()
    }
    
    @objc func stop() {
        isSensingStarted = false
        initStatusBar()
        if UserInfoDao().getLabName() != nil {
            observer.quit()
        }
        sensing.stop()
    }
    
    @objc func start_notification() {
        print("start_nortify")
        NScenter.delegate = self
        let notification = NSUserNotification()
        // アプリ名を表示
        notification.contentImage = NSImage(named: "white")
        notification.title = (Bundle.main.infoDictionary?[kCFBundleNameKey as String])! as? String
        notification.subtitle = "計測を開始しました。"
        NScenter.deliver(notification)
    }
    
    @objc func login() {}
    
    @objc func quit() {
        sensing.quit()
        // アプリケーションの終了
        NSApplication.shared.terminate(self)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func addMemberActivity(name: String, activity: String) {
        let item: NSMenuItem = NSMenuItem()
        if activity == "break" {
            item.title = name + ": " + "お休み中"
            item.image = NSImage(named: "red")
            item.isEnabled = false
            item.identifier = NSUserInterfaceItemIdentifier(name)
            statusBarMenu.addItem(item)
        } else {
            item.title = name + ": " + activity
            item.image = NSImage(named: "blue")
            item.identifier = NSUserInterfaceItemIdentifier(name)
            item.isEnabled = false
            statusBarMenu.addItem(item)
        }
    }
}

struct PlaygroundStr: Codable {
    let _id: String
    let name: String
    let createdAt: String
    let __v: Int
}
