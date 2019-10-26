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
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let TIMER_NORMAL_SEC = 3.0
    let TIMER_SITTING_SEC = 10.0
    // 座りすぎアラートが作動する文字数のしきい値
    let KEYNUM_THRESHOLD = 5

    var statusBarItem: NSStatusItem!
    let loginPopOver = NSPopover()
    let joinLabPopOver = NSPopover()
    var isStopped = false
    var count = 1
    static var keyCount = 0
    static var keyCountForSitting = 0
    static var appName = ""
    var arrayFlag: [Bool] = [false, false, false, false, false]
    var wifiDict:Dictionary<String, String> = [:]
    /* タイマー変数 */
    var timerNormal = Timer()
    var timerSitting = Timer()
    var stopWatchTimer = Timer()
    var startTime = Date()
    
    override init(){
        print("Appdelegete init!!")
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {

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
            statusBarMenu.addItem(
                withTitle: "計測開始",
                action: #selector(AppDelegate.start),
                keyEquivalent: "s")
            statusBarMenu.addItem(
                withTitle: "計測停止",
                action: #selector(AppDelegate.stop),
                keyEquivalent: "t")
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
        
        self.stopWatchTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true
        )
        
        startTime = Date()

//        RunLoop.current.run()
        let d = Keylogger()
        OperationQueue().addOperation({ () -> Void in
    
            while(!self.isStopped) {
                d.start()
            }

        })
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
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間 単位は秒
        let currentTime = Date().timeIntervalSince(startTime)
        
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
        
//        print(currentTime, minute, second, msec)
        let ssid = CWWiFiClient.init().interface()?.ssid() ?? String()
        
        if ssid != "" {
            wifiDict[ssid] = String(Int(currentTime))
        }
//        // %02d： ２桁表示、0で埋める
//        let sMinute = String(format:"%02d", minute)
//        let sSecond = String(format:"%02d", second)
//        let sMsec = String(format:"%02d", msec)
        
//        timerMinute.text = sMinute
//        timerSecond.text = sSecond
//        timerMSec.text = sMsec
        
    }
    
    @objc func keyCountUp(key: String) {
        print("keyCountUp:", key, AppDelegate.keyCount)
        AppDelegate.keyCount += 1
    }
    
    @objc func keyCountUpForSitting(key: String) {
        AppDelegate.keyCountForSitting += 1
    }
    
    @objc func loggerStart() {
        print(AppDelegate.appName, AppDelegate.keyCount)
    }

    /* タイマー関数 */
    @objc func checkLongSitting() {
        print("checkLongSitting: ", AppDelegate.keyCountForSitting)
        if (AppDelegate.keyCountForSitting > KEYNUM_THRESHOLD) {
            print("detect: threshold over")
            arrayFlag.removeLast()
            arrayFlag.insert(true, at: 0)
        } else {
            arrayFlag.removeLast()
            arrayFlag.insert(false, at: 0)
        }
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
        
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
        
        print(wifiDict)
    }
    
    @objc func login() {
        
    }
    
    @objc func wifi() {
        print("wifi", CWWiFiClient.init().interface()?.ssid() ?? String())
    }
    
    @objc func quit(){
        //アプリケーションの終了
        NSApplication.shared.terminate(self)
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
        
        print(wifiDict)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
    }

}

struct PlaygroundStr: Codable {
    let _id: String
    let name: String
    let createdAt: String
    let __v: Int
}
