//
//  HistoryView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/14.
//

import SwiftUI

struct HistoryView: View{
    
    @ObservedObject var eventManager: EventDispatcher
    // binding from @main
    @Binding var historyRange: TimeRange
    @Binding var subscribedLoc: Location
    
    // filter events by users preferences
    var events: [Event] {
        eventManager.event.reversed().filter { event in
            event.eventTime > Calendar.current.date(byAdding: .day, value: (-1*historyRange.getDays()), to: Date()) ?? .distantPast
        }
    }
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("history-title-string")
                    .font(.largeTitle)
                    .bold()
                .padding(.all)
                if(Date().timeIntervalSince(eventManager.event.last?.eventTime ?? Date(timeIntervalSince1970: 0)) < 24 * 3600){
                    ActiveStatusIndicator()
                }
            }
            Rectangle()
                .frame(width: UIScreen.screenWidth - UIScreen.baseLine, height: 1)
                .padding(.leading)
                .offset(y:-15)
            
            ScrollView {
                VStack {
                    ForEach(events, id: \.id){ event in
                        EventInfoBlock(e: event)
                    }
                }
            }.frame(width: UIScreen.screenWidth)
        }
    }
}

//struct HistoryView_Preview: PreviewProvider {
//    static var previews: some View {
//        HistoryView(historyRange: timeRange.projected)
//    }
//}
