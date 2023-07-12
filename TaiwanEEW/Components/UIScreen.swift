//
//  UIScreen.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/3/26.
//

import Foundation
import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    static let baseLine = (screenWidth-340)/3
}
