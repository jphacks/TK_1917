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
    static var TIMER_NORMAL_SEC = 30.0
    static var TIMER_SITTING_SEC = 30.0
    // 座りすぎアラートで使う文字数のしきい値
    static var KEYNUM_THRESHOLD = 10
    // この回数以上連続でしきい値を超えたらアラートを出す
    static var ITERATION_NUM = 5
    
    // アプリケーションログの最大記録数
    static let MAX_APPLOG = 30
    
    var isStopped = false
    var count = 1
    static var keyCount = 0
    static var keyCountForSitting = 0
    static var appName = ""
    static var domainName = ""
    static var appLogList: [String] = []
    static var categoryLogList: [String] = []
    static var dateList: [Date] = []
    
    var arrayFlag: [Bool] = []
    var wifiDict: [String: String] = [:]
    /* タイマー変数 */
    var timerNormal = Timer()
    var timerSitting = Timer()
    var stopWatchTimer = Timer()
    var startTime = Date()
    let NScenter = NSUserNotificationCenter.default
    var eventMonitor: Any?
    var observer: Any?
    
    var categoryData: Data?
    
    static var categories: Category!
    
    override init() {}
    
    func start() {
        Sensing.TIMER_NORMAL_SEC = UserDefaults.standard.double(forKey: "normalTimer")
        Sensing.TIMER_SITTING_SEC = UserDefaults.standard.double(forKey: "sittingTimer")
        Sensing.KEYNUM_THRESHOLD = UserDefaults.standard.integer(forKey: "keyNumThreshold")
        
        print("timer", Sensing.TIMER_NORMAL_SEC, Sensing.TIMER_SITTING_SEC)
        /* タイマー実行 */
        timerNormal = Timer.scheduledTimer(
            timeInterval: Sensing.TIMER_NORMAL_SEC, // 実行する時間
            target: self,
            selector: #selector(CountDown), // 実行関数
            userInfo: nil,
            repeats: true
        )
        
        /* タイマー実行 */
        timerSitting = Timer.scheduledTimer(
            timeInterval: Sensing.TIMER_SITTING_SEC, // 実行する時間
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
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: sensingHandler)
        
        observer = NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(activated(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        
//        categoryData = try? Sensing.getJSONData()
//        categories = try? JSONDecoder().decode(Category.self, from: categoryData!)
        let decoder = JSONDecoder()
        do {
            let d = UserDefaults.standard.data(forKey: "cat")
            if d != nil {
                let data = try decoder.decode(Category.self, from: d!)
                Sensing.categories = data
            } else {
                Sensing.categories = Category(app: ["writing": ["QOLAB"], "survey": [], "break": [], "implementation": []], domain: ["writing": [], "survey": [], "break": [], "implementation": []])
            }
            
        } catch {}
    }
    
    @objc func activated(_ notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let name = app.localizedName {
            Sensing.appName = name
//            print(name)
        }
        let domainName = getDomainNameOfChrome()
        
        var category = ""
        if Sensing.appName == "Google Chrome" {
            print("before split: ", domainName)
            category = categorySplitDomain(domain: domainName)
        } else {
            category = categorySplitApp(app: Sensing.appName)
        }
        print("category", category)
        addActivityLog(app: Sensing.appName, domain: domainName, category: category)
    }
    
    func sensingHandler(event: NSEvent) {
        // not called
        Sensing.appName = NSWorkspace().frontmostApplication!.localizedName ?? ""
        keyCountUp(key: event.characters!)
        keyCountUpForSitting(key: event.characters!)
    }
    
    public static func getJSONData() throws -> Data? {
        guard let path = Bundle.main.path(forResource: "defaultCategory", ofType: "json") else { return nil }
        print(path)
        let url = URL(fileURLWithPath: path)
        
        return try? Data(contentsOf: url)
    }
    
    func addActivityLog(app: String, domain: String, category: String) {
        if Sensing.appLogList.count >= Sensing.MAX_APPLOG {
            Sensing.appLogList.removeFirst()
            Sensing.categoryLogList.removeFirst()
            Sensing.dateList.removeFirst()
        }
        if app == "Google Chrome" {
            if !Sensing.appLogList.contains(domain) {
                Sensing.appLogList.append(domain)
            }
        } else {
            if !Sensing.appLogList.contains(app) {
                Sensing.appLogList.append(app)
            }
        }
        
        if !Sensing.appLogList.contains(app) || !Sensing.appLogList.contains(domain) {
            Sensing.categoryLogList.append(category)
        }
    }
    
    func getActivityCategory() -> String {
        let domainName = getDomainNameOfChrome()
        
        var category = ""
        if Sensing.appName == "Google Chrome" {
            print("before split: ", domainName)
            category = categorySplitDomain(domain: domainName)
        } else {
            category = categorySplitApp(app: Sensing.appName)
        }
        return category
    }
    
    func categorySplitDomain(domain: String) -> String {
        let categoryDict = Sensing.categories.domain
        var categoryName = ""
        for category in categoryDict {
            let key = category.key
            switch key {
            case CategoryName.survey.rawValue:
                categoryName = category.value.contains(domain) ? CategoryName.survey.rawValue : "other"
            case CategoryName.implementation.rawValue:
                categoryName = category.value.contains(domain) ? CategoryName.implementation.rawValue : "other"
            case CategoryName.writing.rawValue:
                categoryName = category.value.contains(domain) ? CategoryName.writing.rawValue : "other"
            case CategoryName.breakTime.rawValue:
                categoryName = category.value.contains(domain) ? CategoryName.breakTime.rawValue : "other"
            default:
                print("default")
            }
            
            if categoryName != "other" {
                return categoryName
            }
        }
        return categoryName
    }
    
    func categorySplitApp(app: String) -> String {
        let categoryDict = Sensing.categories.app
        var categoryName = ""
        for category in categoryDict {
            let key = category.key
            switch key {
            case CategoryName.survey.rawValue:
                categoryName = category.value.contains(app) ? CategoryName.survey.rawValue : "other"
            case CategoryName.implementation.rawValue:
                categoryName = category.value.contains(app) ? CategoryName.implementation.rawValue : "other"
            case CategoryName.writing.rawValue:
                categoryName = category.value.contains(app) ? CategoryName.writing.rawValue : "other"
            case CategoryName.breakTime.rawValue:
                categoryName = category.value.contains(app) ? CategoryName.breakTime.rawValue : "other"
            default:
                print("default")
            }
            
            if categoryName != "other" {
                return categoryName
            }
        }
        return categoryName
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間 単位は秒
        let currentTime = Date().timeIntervalSince(startTime)
        
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
        Sensing.domainName = getDomainNameOfChrome()
        Sensing.domainName = Sensing.domainName == "" ? "Error" : Sensing.domainName
        
        let category = getActivityCategory()
        
        let paramDto = UserActivityRequest(activityName: "KeyCountAndAppName", data: ActivityData(appName: Sensing.appName, typeCount: Sensing.keyCount), category: category)
        APIClient.postActivity(activity: paramDto) { _ in }
        let chromeParamDto = ChromeTabRequest(activityName: "browsing", data: ChromeTabData(status: "complete", url: "https://" + Sensing.domainName), category: category)
        if Sensing.domainName != "qolab-a0324.web.app", Sensing.domainName != "qolab-a0324.firebaseapp.com", Sensing.appName == "Google Chrome" {
            APIClient.postActivity(activity: chromeParamDto) { _ in }
        }
    }
    
    func getDomainNameOfChrome() -> String {
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
        if Sensing.keyCountForSitting > Sensing.KEYNUM_THRESHOLD {
            print("detect: threshold over")
            arrayFlag.insert(true, at: 0)
            
        } else {
            arrayFlag.insert(false, at: 0)
        }
        
        if arrayFlag.count > Sensing.ITERATION_NUM {
            arrayFlag.removeLast()
        }
        
        let orderedSet = NSOrderedSet(array: arrayFlag)
        let uniqueValues = orderedSet.array as! [Bool]
        
        // 全てtrueだった場合 座りすぎ
        if uniqueValues[0], uniqueValues.count == 1, arrayFlag.count == Sensing.ITERATION_NUM {
            print("座りすぎです！！！！！！")
            notification()
            // flagを初期化
            arrayFlag = []
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
