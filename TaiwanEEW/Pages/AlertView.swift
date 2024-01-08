//
//  AlertView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/5.
//

import SwiftUI

struct AlertView: View {
    // Instance
    @ObservedObject var eventManager: EventDispatcher
    // binding from @main
//    @Binding var historyRange: TimeRange
    @Binding var subscribedLoc: Location
    @EnvironmentObject var sheetManager: SheetManager
    @Environment(\.colorScheme) var colorScheme
    var publishedTime: Date {eventManager.publishedTime}
    var arrivalTime: Date {eventManager.arrivalTime}
    var intensity: String {eventManager.intensity}
    var lastPingTime: Date {eventManager.lastPingTime}
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            let color = (colorScheme == .dark ? Color.black : Color.white)
            
            Rectangle().foregroundColor(color)
            GeometryReader { reader in
                    color
                    .frame(height: reader.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
            //ConnectionStatusBar()
            
            VStack(alignment: .leading){
                pageInfo
                AlertStatusBar(arrivalTime: arrivalTime, intensity: intensity).offset(x:UIScreen.baseLine)
                alertInfo
                arrivalClockTimeBar.offset(x:UIScreen.baseLine)
                Spacer()
            }
        }
        .analyticsScreen(name: "AlertView", extraParameters: [
            "watch_location" : subscribedLoc.getTopicKey()
        ])
    }
}

private extension AlertView {
    
    var pageInfo: some View {
        Group {
            
            HStack {
                LocationBlock(subscribedLoc: subscribedLoc).offset(x:UIScreen.baseLine)
                Spacer()
                ConnectionStatusButton(lastPingTime: lastPingTime)
            }
            
            Group {
                Text("alert-title-string").font(.largeTitle.bold())
            }.offset(x: UIScreen.baseLine)
            Text("\(dateFormatter.string(from: publishedTime)) publish-string")
                .padding(.bottom, 20.0)
                .offset(x: UIScreen.baseLine, y:5)
        }
    }
    
    var alertInfo: some View {
        Group {
            HStack {
                Spacer()
                TimeBlock(arrivalTime: arrivalTime)
                Spacer()
                IntensityBlock(intensity: intensity)
                Spacer()
            }
        }
    }
    
    var arrivalClockTimeBar: some View {
        Group {
            HStack (alignment: .center) {
                ZStack {
                    Rectangle().frame(width: 170.0, height: 40.0).clipped().cornerRadius(/*@START_MENU_TOKEN@*/7.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("Pad"))
                    Text("est-arrival-time-string").font(.system(size:20))
                }
                Text(dateFormatter.string(from: arrivalTime)).font(.system(size: 20))
            }
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    @State static var testLoc = Location.taipei
    
    static var previews: some View {
        AlertView(eventManager: EventDispatcher(subscribedLoc: $testLoc), subscribedLoc: $testLoc).environment(\.locale, Locale.init(identifier: "en"))
            .environmentObject(SheetManager())
        
        AlertView(eventManager: EventDispatcher(subscribedLoc: $testLoc), subscribedLoc: $testLoc).environment(\.colorScheme, .dark)
    }
}
