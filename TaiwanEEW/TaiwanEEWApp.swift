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
//            else if !UserDefaults.standard.bool(forKey: "HasLaunchedBefore_1.1"){
//
//                // Update ver 1.1 launched before flag
//                UserDefaults.standard.set(true, forKey: "HasLaunchedBefore_1.1")
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
                            FCMManager.setNotifyMode(location: subscribedLoc, threshold: notifyThreshold)
                        }, onNotifyThresholdChanged: { newValue in
                            notifyThreshold = newValue
                            FCMManager.setNotifyMode(location: subscribedLoc, threshold: notifyThreshold)
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
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei                  // (duplicate)
    @AppStorage("notifyThreshold") var notifyThreshold: NotifyThreshold = .eg3          // (duplicate)
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true                         // (duplicate)
    func seperate(){ print(); print("  -------- incoming notification --------")}       // for debugging only
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // MARK: version 1.1 adaptation
        // Check if the app is on its first launch for version "1.1"
        let isFirstLaunchV11 = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore_1.1")
        print("[isFirstLaunchV11] = \(isFirstLaunchV11)")
        
        if isFirstLaunchV11 {
            // Unsubscribe all topics and resubscribe using new method.
            print("--- First launch on version 1.1 ---")
            NotifyThreshold.allCases.forEach { topic in
                Messaging.messaging().unsubscribe(fromTopic: topic.getTopicKey()) { error in
                    print("[FCM ver1.1 adaptation] Unsubscribed to [\(topic.getTopicKey())] topic")
                }
            }
            FCMManager.setNotifyMode(location: subscribedLoc, threshold: notifyThreshold)
            
            // Update ver 1.1 launched before flag later in what's new page (ver 1.1)
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
    private static func generateTopicKeys(for location: Location, threshold: NotifyThreshold) -> [String] {
        var topicsToSubscribe: [String] = []

        switch threshold {
        case .off:
            topicsToSubscribe.append(threshold.getTopicKey())
//            case .test:
//                topicsToSubscribe.append(threshold.getTopicKey())
        default:
            let startIndex = threshold.getIntValue()
            let endIndex = 4
            let locationKey = location == .taipei ? "" : location.getTopicKey() // note taipei topics does not require location prefix.
            for i in startIndex...endIndex {
                let topic = locationKey + "eg\(i)"
                topicsToSubscribe.append(topic)
            }
        }

        return topicsToSubscribe
    }

    private static var defaults = UserDefaults.standard

        static func subscribe(to topic: String) {
            if !isSubscribed(to: topic) {
                // Perform the subscribe operation here.
                Messaging.messaging().subscribe(toTopic: topic) { error in
                    print("[FCM] Subscribed to [\(topic)] topic")
                }
                currentSubscribedTopics[topic] = true
                saveSubscriptionStatus()
            }
        }

        static func unsubscribe(from topic: String) {
            if isSubscribed(to: topic) {
                // Perform the unsubscribe operation here.
                Messaging.messaging().unsubscribe(fromTopic: topic) { error in
                    print("[FCM] Unsubscribed from [\(topic)] topic")
                }
                currentSubscribedTopics[topic] = nil
                saveSubscriptionStatus()
            }
        }

        static func isSubscribed(to topic: String) -> Bool {
            return currentSubscribedTopics[topic] != nil
        }

        static func setNotifyMode(location: Location, threshold: NotifyThreshold) {
            let newTopicKeys = generateTopicKeys(for: location, threshold: threshold)

            // Unsubscribe from unnecessary topics
            currentSubscribedTopics.keys.forEach { topic in
                if !newTopicKeys.contains(topic) {
                    unsubscribe(from: topic)
                }
            }

            // Subscribe to new topics
            newTopicKeys.forEach { topic in
                subscribe(to: topic)
            }
        }


        private static var currentSubscribedTopics: [String: Bool] {
            get {
                return defaults.dictionary(forKey: "subscribedTopics") as? [String: Bool] ?? [:]
            }
            set {
                defaults.set(newValue, forKey: "subscribedTopics")
            }
        }

        private static func saveSubscriptionStatus() {
            currentSubscribedTopics = currentSubscribedTopics // Force saving to UserDefaults
        }

}
