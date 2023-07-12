//
//  NotificationManager.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/6/12.
//

import Foundation
import UserNotifications

struct NotificationManager {
    func push(_ title:String, _ body:String) {
        
        print("                                --> sending notification -->")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
