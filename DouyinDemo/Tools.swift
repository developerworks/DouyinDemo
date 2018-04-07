//
//  Tools.swift
//  RefreshableCollectionViewController
//
//  Created by hezhiqiang on 2018/4/6.
//  Copyright © 2018年 Totorotec. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyBeaver
import DeviceKit

class Tools: NSObject {
    static func requestUserNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if !accepted {
                print("用户不允许消息通知!")
            }
        }
    }
    
    static func configLogger() {
        let device = Device()
        if device.isSimulator {
            let file = FileDestination()
            file.minLevel = .verbose
            file.logFileURL = URL(fileURLWithPath: "/tmp/swiftybeaver.log")
            file.asynchronously = false
            SwiftyBeaver.addDestination(file)
        }
    }
}
