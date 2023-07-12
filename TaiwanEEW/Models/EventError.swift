//
//  EventError.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/16.
//

import Foundation

enum EventError: Error {
    case noLastEvent
    case noEventTime
    case noSeconds
    case invalidArrivalCountdown
}
