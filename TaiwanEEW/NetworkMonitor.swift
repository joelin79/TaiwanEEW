//
//  NetworkMonitor.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/20.
//
/* Source by UdayKiran M: https://medium.com/@udaykiran.munaga/swift-check-for-internet-connectivity-14e355fa10c5
 */

import Foundation
import Network

class NetworkMonitor : ObservableObject{
    @Published private(set) var connected = false
    
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("[NetworkMonitor] We're connected!")
                // post connected notification
            } else {
                print("[NetworkMonitor] No network connection.")
                // post disconnected notification
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
