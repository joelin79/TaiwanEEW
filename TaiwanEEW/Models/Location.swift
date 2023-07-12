//
//  Location.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/8/19.
//

import Foundation
import SwiftUI

enum Location: String, CaseIterable, Identifiable, Codable{
    case taipei, hsinchu, taichung, kaohsiung, pingtung, taitung, hualian, yilan
    var id: Self { self }
    
    func getDisplayName() -> LocalizedStringKey {
        switch self {
        case .taipei:
            return LocalizedStringKey("taipei-string")
        case .hsinchu:
            return LocalizedStringKey("hsinchu-string")
        case .taichung:
            return LocalizedStringKey("taichung-string")
        case .kaohsiung:
            return LocalizedStringKey("kaohsiung-string")
        case .pingtung:
            return LocalizedStringKey("pingtung-string")
        case .taitung:
            return LocalizedStringKey("taitung-string")
        case .hualian:
            return LocalizedStringKey("hualian-string")
        case .yilan:
            return LocalizedStringKey("yilan-string")
        }
    }
}
