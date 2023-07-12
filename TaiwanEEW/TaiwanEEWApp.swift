//
//  TaiwanEEWApp.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/5.
//
//  This file contains the main entry point of the TaiwanEEW app.
//

import SwiftUI
import Firebase
import UserNotifications
import BackgroundTasks


@main
struct TaiwanEEWApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    let appRefreshInterval: TimeInterval = 10           // seconds
    
    // selection variables accessable between views
    @AppStorage("historyRange") var historyRange: TimeRange = .year
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei
    @StateObject var sheetManager = SheetManager()
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("notifyThreshold") var notifyThreshold: NotifyThreshold = .eg3

    var body: some Scene {
        WindowGroup {
            let _ = print("[Init] isFirstLaunch is currently \(isFirstLaunch)")
            if isFirstLaunch {
                FirstLaunchView(onDismiss: {
                    withAnimation {
                        isFirstLaunch = false
                    }
                })
            } else {
                TabView {
                    AlertView(eventManager: EventDispatcher(subscribedLoc: $subscribedLoc), subscribedLoc: $subscribedLoc)
                        .environmentObject(sheetManager)
                        .tabItem {
                            Label("Alert", systemImage: "exclamationmark.triangle")    // TODO: localization
                        }
                    HistoryView(eventManager: EventDispatcher(subscribedLoc: $subscribedLoc), historyRange: $historyRange, subscribedLoc: $subscribedLoc)
                        .tabItem {
                            Label("History", systemImage: "chart.bar.doc.horizontal")
                        }
                    SettingsView(
                        onHistoryRangeChanged: { newValue in
                            historyRange = newValue
                        }, onSubscribedLocChanged: { newValue in
                            subscribedLoc = newValue
                        }, onNotifyThresholdChanged: { newValue in
                            notifyThreshold = newValue
                            FCMManager.setNotifyMode(threshold: notifyThreshold)
                        })
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
    }
    
    
}

// MARK: Notification Handling
// MARK: https://www.youtube.com/watch?v=TGOF8MqcAzY&ab_channel=DesignCode
// MARK: https://designcode.io/swiftui-advanced-handbook-push-notifications-part-2
class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage("notifyThreshold") var notifyThreshold: NotifyThreshold = .eg3          // (duplicate)
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true                         // (duplicate)
    func seperate(){ print(); print("  -------- incoming notification --------")}       // for debugging only
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if isFirstLaunch {
            FCMManager.setNotifyMode(threshold: notifyThreshold)                    // topic subscription on first launch (default: eg3)
        }
        
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken)                                  // This token can be used for testing notifications on FCM
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // Print message ID and full message.
    if let messageID = userInfo[gcmMessageIDKey] {
        seperate()                                                          // for debugging use only
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}



// Topic subscription management
class FCMManager {
    static func setNotifyMode(threshold: NotifyThreshold) {
        
        NotifyThreshold.allCases.forEach { topic in
            if topic != .eg4 {
                Messaging.messaging().unsubscribe(fromTopic: topic.getTopicKey()) { error in
                    print("[FCM] Unsubscribed to [\(topic.getTopicKey())] topic")
                }
            }
        }
        
        switch threshold {
        case .eg0:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg0.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg0] topic")
            }
            fallthrough
        case .eg1:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg1.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg1] topic")
            }
            fallthrough
        case .eg2:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg2.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg2] topic")
            }
            fallthrough
        case .eg3:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg3.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg3] topic")
            }
            fallthrough
        case .eg4:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.eg4.getTopicKey()) { error in
                print("[FCM] Subscribed to [eg4] topic")
            }
        case .test:
            Messaging.messaging().subscribe(toTopic: NotifyThreshold.test.getTopicKey()) { error in
                print("[FCM] Subscribed to [test] topic")
            }
        }
    }
}
