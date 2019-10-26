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
    
    let TIMER_NORMAL_SEC = 3.0
    let TIMER_SITTING_SEC = 10.0
    // 座りすぎアラートが作動する文字数のしきい値
    let KEYNUM_THRESHOLD = 5

    var statusBarItem: NSStatusItem!
    let loginPopOver = NSPopover()
    let registerPopOver = NSPopover()
    var isStopped = false
    var count = 1
    static var keyCount = 0
    static var keyCountForSitting = 0
    static var appName = ""
    var arrayFlag: [Bool] = [false, false, false, false, false]
    /* タイマー変数 */
    var timerNormal = Timer()
    var timerSitting = Timer()
    
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
        
        let userInfo = UserInfoDao().getUserInfo()
        
        if userInfo == nil {
            statusBarMenu.addItem(
                withTitle: "新規登録",
                action: #selector(AppDelegate.openRegisterPage(_:)),
                keyEquivalent: "")

            statusBarMenu.addItem(
                withTitle: "ログイン",
                action: #selector(AppDelegate.toggleLoginPopover(_:)),
                keyEquivalent: "")
        } else {
            statusBarMenu.addItem(
                withTitle: "計測開始",
                action: #selector(AppDelegate.start),
                keyEquivalent: "s")
            statusBarMenu.addItem(
                withTitle: "計測停止",
                action: #selector(AppDelegate.stop),
                keyEquivalent: "s")
            statusBarMenu.addItem(
                withTitle: "ログアウト",
                action: #selector(AppDelegate.logout(_:)),
                keyEquivalent: "w")
        }
        
        statusBarMenu.addItem(
            withTitle: "終了",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "q")

        
        let storyboard = NSStoryboard.init(name: "Auth", bundle: nil)
        let loginViewController = storyboard.instantiateController(withIdentifier: "login")
        let registerViewController = storyboard.instantiateController(withIdentifier: "register")
        loginPopOver.contentViewController = (loginViewController as! NSViewController)
        registerPopOver.contentViewController = (registerViewController as! NSViewController)
        
    }
    
    func initStatusBar() {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage.init(named: "iconW")
        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        
        statusBarItem.menu = statusBarMenu
        
        let userInfo = UserInfoDao().getUserInfo()
        
        if userInfo == nil {
            statusBarMenu.addItem(
                withTitle: "新規登録",
                action: #selector(AppDelegate.openRegisterPage(_:)),
                keyEquivalent: "")

            statusBarMenu.addItem(
                withTitle: "ログイン",
                action: #selector(AppDelegate.toggleLoginPopover(_:)),
                keyEquivalent: "")
        } else {
            statusBarMenu.addItem(
                withTitle: "計測開始",
                action: #selector(AppDelegate.start),
                keyEquivalent: "s")
            statusBarMenu.addItem(
                withTitle: "計測停止",
                action: #selector(AppDelegate.stop),
                keyEquivalent: "s")
            statusBarMenu.addItem(
                withTitle: "ログアウト",
                action: #selector(AppDelegate.logout(_:)),
                keyEquivalent: "w")
        }
        
        statusBarMenu.addItem(
            withTitle: "終了",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "q")
    }
    
    @objc func toggleLoginPopover(_ sender: Any){
        if loginPopOver.isShown{
            closeLoginPopover(sender)
        }else{
            closeRegisterPopover(sender)
            showLoginPopover(sender)
        }
    }
    
    @objc func openRegisterPage(_ sender: Any){
        NSWorkspace.shared.open(URL(string: "https://qolab-a0324.web.app/signup/")!)
    }

    func closeRegisterPopover(_ sender: Any){
        registerPopOver.performClose(sender)
    }
    
    func showLoginPopover(_ sender: Any){
        if let button = statusBarItem.button{
            loginPopOver.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    @objc func logout(_ sender: Any) {
        UserDefaults().removeObject(forKey: UserInfoDao.USER_INFO)
        initStatusBar()
    }

    public func closeLoginPopover(_ sender: Any){
        loginPopOver.performClose(sender)
    }
    
    @objc func register () {
        
    }
    
    @objc func start () {
        /* タイマー実行 */
        self.timerNormal = Timer.scheduledTimer(
                    timeInterval: TIMER_NORMAL_SEC,//実行する時間
                    target: self,
                    selector: #selector(self.CountDown),//実行関数
                    userInfo: nil,
                    repeats: true
        )
        
        /* タイマー実行 */
        self.timerSitting = Timer.scheduledTimer(
                    timeInterval: TIMER_SITTING_SEC,//実行する時間
                    target: self,
                    selector: #selector(self.checkLongSitting),//実行関数
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
        self.loggerStart()
        // keyCountをリセット
        AppDelegate.keyCount = 0
//        /* 10秒かカウントしたらタイマーストップ */
//        if (self.count > 10) {
//            timer.invalidate()
//        }
    }
    
    @objc func keyCountUp(key: String) {
        print("keyCountUp:", key, AppDelegate.keyCount)
        AppDelegate.keyCount += 1
    }
    
    @objc func keyCountUpForSitting(key: String) {
        AppDelegate.keyCountForSitting += 1
    }
    
    @objc func loggerStart() {
        print("logger_start")
        print(AppDelegate.appName, AppDelegate.keyCount)
    }

    /* タイマー関数 */
    @objc func checkLongSitting() {
        print("checkLongSitting: ", AppDelegate.keyCountForSitting)
        if (AppDelegate.keyCountForSitting > KEYNUM_THRESHOLD) {
            arrayFlag.removeLast()
            arrayFlag.insert(true, at: 0)
        } else {
            arrayFlag.removeLast()
            arrayFlag.insert(false, at: 0)
        }
        print("array", arrayFlag)
        let orderedSet = NSOrderedSet(array: arrayFlag)
        let uniqueValues = orderedSet.array as! [Bool]
        
        // 全てtrueだった場合 座りすぎ
        if (uniqueValues[0] && uniqueValues.count == 1) {
            print("座りすぎです！！！！！！")
        }
        // keyCountForSittingをリセット
        AppDelegate.keyCountForSitting = 0
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
