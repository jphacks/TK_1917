//
//  Sensing.swift
//  QOLAB
//
//  Created by Oshima Masachika on 2019/10/27.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Foundation
import Cocoa
import CoreWLAN

class Sensing{
    let TIMER_NORMAL_SEC = 5.0
    let TIMER_SITTING_SEC = 10.0
    // 座りすぎアラートが作動する文字数のしきい値
    let KEYNUM_THRESHOLD = 5
    
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
    
    init() {

    }
    
    func start() {
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

        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            // not called
            print(event.characters!)
            Sensing.appName = NSWorkspace().frontmostApplication!.localizedName ?? ""
            self.keyCountUp(key: event.characters!)
            self.keyCountUpForSitting(key: event.characters!)
        }
        
        NSWorkspace.shared.notificationCenter.addObserver(self,selector: #selector(activated(_:)),name: NSWorkspace.didActivateApplicationNotification,object: nil)
        
    }
    
    @objc func activated(_ notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let name = app.localizedName
        {
            Sensing.appName = name
            print(name)
        }
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
    }
        
    /* タイマー関数 */
    @objc func CountDown() {
        self.count += 1
        print("count:", count)
        self.loggerStart()
        // keyCountをリセット
        Sensing.keyCount = 0
        
        
//        /* 10秒かカウントしたらタイマーストップ */
//        if (self.count > 10) {
//            timer.invalidate()
//        }
    }
    
    @objc func keyCountUp(key: String) {
        print("keyCountUp:", key, Sensing.keyCount)
        Sensing.keyCount += 1
    }
    
    @objc func keyCountUpForSitting(key: String) {
        Sensing.keyCountForSitting += 1
    }
    
    @objc func loggerStart() {
        print(Sensing.appName, Sensing.keyCount)
        let paramDto = UserActivityRequest(activityName: "napp_activity", data: ActivityData(appName: Sensing.appName, typeCount: Sensing.keyCount))
        APIClient.postActivity(activity: paramDto) {_ in }
                
    }

    /* タイマー関数 */
    @objc func checkLongSitting() {
        print("checkLongSitting: ", Sensing.keyCountForSitting)
        if (Sensing.keyCountForSitting > KEYNUM_THRESHOLD) {
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
        Sensing.keyCountForSitting = 0
    }
    
    @objc func wifi() {
        print("wifi", CWWiFiClient.init().interface()?.ssid() ?? String())
    }
    
    func stop() {
        self.isStopped = true
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
        
        print(wifiDict)
    }
    
    func quit() {
        timerSitting.invalidate()
        timerNormal.invalidate()
        stopWatchTimer.invalidate()
        
        print(wifiDict)
    }
}
