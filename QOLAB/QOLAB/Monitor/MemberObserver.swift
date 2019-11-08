//
//  MemberObserver.swift
//  QOLAB
//
//  Created by Takuto Mori on 2019/11/05.
//  Copyright © 2019 Takuto Mori. All rights reserved.
//

import Cocoa
import Foundation

class MemberObserver: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    let TIMER_NORMAL_SEC = 5.0
    
    var count = 1
    
    var timerNormal = Timer()
    
    var appDelegate: AppDelegate?
    
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
    }
    
    /* タイマー関数 */
    @objc func CountDown() {
        fetchMembverActivity()
    }
    
    @objc func fetchMembverActivity() {
        APIClient.fetchMemberActivities { result in
            DispatchQueue.main.sync {
                self.appDelegate = NSApplication.shared.delegate as? AppDelegate
                self.appDelegate?.initStatusBar()
                self.appDelegate?.statusBarMenu.addItem(NSMenuItem.separator())
                result?.forEach { arr in
                    var name = "名称未設定"
                    if arr.name == nil {
                        name = arr.email
                    } else {
                        name = arr.name
                    }
                    self.appDelegate?.addMemberActivity(name: name, activity: arr.activity)
                }
            }
        }
    }
    
    func quit() {
        timerNormal.invalidate()
    }
}
