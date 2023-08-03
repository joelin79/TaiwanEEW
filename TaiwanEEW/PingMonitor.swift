//
//  PingMonitor.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/7/31.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

class PingMonitor: ObservableObject{
    @Published private(set) var ping: [Ping] = []
    @Published private(set) var lastPingId = ""
    @Published private(set) var lastPingTime: Date = Date(timeIntervalSince1970: 0)
    @Published private(set) var intensity: String = "0"
    let db = Firestore.firestore()
    
    init(){
        getPings()
    }
    
    func getPings(){
        
        // listening the collection of the selected location
        db.collection("ping").addSnapshotListener { querySnapshot, error in
            
            // fetch documents into the "documents" array
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            // then decode documents into a compactMap of type Ping array, and store into event
            self.ping = documents.compactMap { document -> Ping? in
                do {
                    return try document.data(as: Ping.self)
                } catch {
                    print("Error decoding document into Ping: \(error)")
                    return nil
                }
            }
            
            // sort Ping by eventTime
            self.ping.sort { $0.pingTime < $1.pingTime }
            
            // set variables
            if let lastPing = self.ping.last
            {
                self.lastPingTime = lastPing.pingTime
            }
        }
    }
}
