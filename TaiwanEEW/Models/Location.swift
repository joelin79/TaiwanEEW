//
//  Location.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/8/19.
//

import Foundation
import SwiftUI

// TODO: Server support for more locations
enum Location: String, CaseIterable, Identifiable, Codable{
//    case keelung, taipei, taoyuan, hsinchu, miaoli, taichung, changhua, yunlin, nantou, chiayi, tainan, kaohsiung, pingtungCity, pingtungHengchun, yilan, hualienCity, hualienYuli, taitung, penghu
    case test /* MARK: Debug */, taipei, hsinchu, taichung, chiayi, tainan, kaohsiung, yilan, hualienCity
    var id: Self { self }
    
    func getDisplayName() -> LocalizedStringKey {
        switch self {
        case .test: /* MARK: Debug */
            return "test" /* MARK: Debug */
//        case .keelung:
//            return LocalizedStringKey("keelung-string")
        case .taipei:
            return LocalizedStringKey("taipei-string")
//        case .taoyuan:
//            return LocalizedStringKey("taoyuan-string")
        case .hsinchu:
            return LocalizedStringKey("hsinchu-string")
//        case .miaoli:
//            return LocalizedStringKey("miaoli-string")
        case .taichung:
            return LocalizedStringKey("taichung-string")
//        case .changhua:
//            return LocalizedStringKey("changhua-string")
//        case .yunlin:
//            return LocalizedStringKey("yunlin-string")
//        case .nantou:
//            return LocalizedStringKey("nantou-string")
        case .chiayi:
            return LocalizedStringKey("chiayi-string")
        case .tainan:
            return LocalizedStringKey("tainan-string")
        case .kaohsiung:
            return LocalizedStringKey("kaohsiung-string")
//        case .pingtungCity:
//            return LocalizedStringKey("pingtung-city-string")
//        case .pingtungHengchun:
//            return LocalizedStringKey("pingtung-hengchun-string")
        case .yilan:
            return LocalizedStringKey("yilan-string")
        case .hualienCity:
            return LocalizedStringKey("hualien-city-string")
//        case .hualienYuli:
//            return LocalizedStringKey("hualien-yuli-string")
//        case .taitung:
//            return LocalizedStringKey("taitung-string")
//        case .penghu:
//            return LocalizedStringKey("penghu-string")
        }
    }
    
    func getTopicKey() -> String {
        switch self {
//        case .pingtungCity:
//            return "pingtung"
//        case .pingtungHengchun:
//            return "pingtung-hengchun"
        case .hualienCity:
            return "hualien"
//        case .hualienYuli:
//            return "hualien-yuli"
        default:
            return self.rawValue
        }
    }
}
