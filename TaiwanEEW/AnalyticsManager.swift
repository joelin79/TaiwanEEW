//
//  AnalyticsManager.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/9/7.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift

final class AnalysicsManager {
    static let shared = AnalysicsManager()
    let debug = true
    
    private init() { }
    
    func logEvent(name: String, params: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
        if(debug){
            print("logEvent: name=\(name) param=\(String(describing: params))")
        }
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
        if(debug){
            print("setUserId: id=\(userId)")
        }
    }
    
    func setUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
        if(debug){
            print("setUserProperty: value=\(String(describing: value)) property=\(property)")
        }
    }
}
