//
//  TimeCounter.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/16.
//

import Foundation

class TimeCounter: ObservableObject{
    var event:Event
    var eventTime: Date
    var estArrival: Date
        
        init(event: Event) {
            
        }
        
        func getEstTime() -> Int {
            self.eventTime = event.eventTime
            self.estArrival = self.eventTime.addingTimeInterval(Double(event.seconds))
            let currentTime = Date()
            return 
        }
    
}
