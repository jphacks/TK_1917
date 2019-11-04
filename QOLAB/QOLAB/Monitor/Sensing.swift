//
//  Sensing.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/10/27.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa
import CoreWLAN
import Foundation

class Sensing: NSObject, NSUserNotificationCenterDelegate {
    let TIMER_NORMAL_SEC = UserDefaults.standard.double(forKey: "normalTimer")
    let TIMER_SITTING_SEC = UserDefaults.standard.double(forKey: "sittingTimer")
    // 座りすぎアラートが作動する文字数のしきい値
    let KEYNUM_THRESHOLD = UserDefaults.standard.integer(forKey: "sittingThreshold")
    
    var isStopped = false
    var count = 1
    static var keyCount = 0
    static var keyCountForSitting = 0
    static var appName = ""
    static var domainName = ""
    var arrayFlag: [Bool] = [false, false, false, false, false]
    var wifiDict: [String: String] = [:]
    /* タイマー変数 */
    var timerNormal = Timer()
    var timerSitting = Timer()
    var stopWatchTimer = Timer()
    var startTime = Date()
    let NScenter = NSUserNotificationCenter.default
    var eventMonitor: Any?
    var observer: Any?
    
    override init() {}
    
    func start() {
        /* タイマー実行 */
        timerNormal = Timer.scheduledTimer(
            timeInterval: TIMER_NORMAL_SEC, // 実行する時間
            target: self,
            selector: #selector(CountDown), // 実行関数
            userInfo: nil,
            repeats: true
        )
        
        /* タイマー実行 */
        timerSitting = Timer.scheduledTimer(
            timeInterval: TIMER_SITTING_SEC, // 実行する時間
            target: self,
            selector: #selector(checkLongSitting), // 実行関数
            userInfo: nil,
            repeats: true
        )
        
        stopWatchTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerCounter),
            userInfo: nil,
            repeats: true
        )
        
        startTime = Date()
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: handler)
        
        observer = NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(activated(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc func activated(_ notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let name = app.localizedName {
            Sensing.appName = name
//            print(name)
        }
    }
    
    func handler(event: NSEvent) {
        // not called
//            print("handler", event.characters!)
        Sensing.appName = NSWorkspace().frontmostApplication!.localizedName ?? ""
        keyCountUp(key: event.characters!)
        keyCountUpForSitting(key: event.characters!)
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間 単位は秒
        let currentTime = Date().timeIntervalSince(startTime)
        
        // fmod() 余りを計算
        let minute = (Int)(fmod(currentTime / 60, 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime)) * 100)
        
//        print(currentTime, minute, second, msec)
        let ssid = CWWiFiClient().interface()?.ssid() ?? String()
        
        if ssid != "" {
            wifiDict[ssid] = String(Int(currentTime))
        }
    }
    
    /* タイマー関数 */
    @objc func CountDown() {
        count += 1
//        print("count:", count)
        loggerStart()
        // keyCountをリセット
        Sensing.keyCount = 0
        
//        /* 10秒かカウントしたらタイマーストップ */
//        if (self.count > 10) {
//            timer.invalidate()
//        }
    }
    
    @objc func keyCountUp(key: String) {
        Sensing.keyCount += 1
    }
    
    @objc func keyCountUpForSitting(key: String) {
        Sensing.keyCountForSitting += 1
    }
    
    @objc func loggerStart() {
        Sensing.domainName = getChromeURL()
        Sensing.domainName = Sensing.domainName == "" ? "Error" : Sensing.domainName
        
        let paramDto = UserActivityRequest(activityName: "KeyCountAndAppName", data: ActivityData(appName: Sensing.appName, typeCount: Sensing.keyCount))
        APIClient.postActivity(activity: paramDto) { _ in }
        let chromeParamDto = ChromeTabRequest(activityName: "browsing", data: ChromeTabData(status: "complete", url: "https://" + Sensing.domainName))
        if Sensing.domainName != "qolab-a0324.web.app", Sensing.domainName != "qolab-a0324.firebaseapp.com", Sensing.appName == "Google Chrome" {
            APIClient.postActivity(activity: chromeParamDto) { _ in }
        }
    }
    
    func getChromeURL() -> String {
        // chromeからアクティブタブのURLを取得するAppleScript
        let myAppleScript = "tell application \"Google Chrome\"\n" +
            "get URL of active tab of first window\n" +
            "end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: myAppleScript)
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&error) {
            let urlString = output.stringValue!
            // urlからドメイン取得
            let url = NSURL(string: urlString)
            if Sensing.appName == "Google Chrome" {
                return (url?.host)!
            }
        } else if error != nil {
            print("error: \(String(describing: error))")
        }
        return ""
    }
    
    /* タイマー関数 */
    @objc func checkLongSitting() {
//        print("checkLongSitting: ", Sensing.keyCountForSitting)
        if Sensing.keyCountForSitting > KEYNUM_THRESHOLD {
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
        if uniqueValues[0], uniqueValues.count == 1 {
            print("座りすぎです！！！！！！")
            notification()
            // flagを初期化
            arrayFlag = [false, false, false, false, false]
        }
        // keyCountForSittingをリセット
        Sensing.keyCountForSitting = 0
    }
    
    @objc func wifi() {
        print("wifi", CWWiFiClient().interface()?.ssid() ?? String())
    }
    
    @objc func notification() {
        print("nortify")
        NScenter.delegate = self
        let notification = NSUserNotification()
        // アプリ名を表示
        notification.contentImage = NSImage(named: "white")
        notification.title = (Bundle.main.infoDictionary?[kCFBundleNameKey as String])! as? String
        notification.subtitle = "座っている時間が長いよ！少し休憩しよう？"
        NScenter.deliver(notification)
    }
    
    func stop() {
        isStopped = true
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        NSEvent.removeMonitor(eventMonitor)
        print(wifiDict)
    }
    
    func quit() {
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
        
        print(wifiDict)
    }
}
