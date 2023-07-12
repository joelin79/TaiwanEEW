////
////  ConnectionStatusBar.swift
////  TaiwanEEW
////
////  Created by Joe Lin on 2022/8/18.
////
//
//import SwiftUI
//import Network
//
//struct ConnectionStatusBar: View {
//    @ObservedObject private var eventManager = EventDispatcher()
//    @ObservedObject private var networkMonitor = NetworkMonitor()
//    @State var isConnected = true
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//        VStack {
//            ZStack {
//                Rectangle()
//                    .frame(height: 30)
//                    .clipped()
//                    .foregroundColor(
//                        isConnected ?
//                            .green : .red
//                    )
//                Text(
//                    isConnected ?
//                    "連線狀態待修" :
//                    "未連線（持續尋找中）"
//                )
//                .foregroundColor(Color.white)
////                .onReceive(timer) { _ in
////                    updateStatus()
////                }
////                .onAppear(){
////                    networkMonitor.startMonitoring()
////                    updateStatus()
////                }
//            }
//        }
//    }
//
//    private func updateStatus() {
//        isConnected = networkMonitor.isReachable
//    }
//
//}
//
//struct ConnectionStatusBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectionStatusBar()
//    }
//}
