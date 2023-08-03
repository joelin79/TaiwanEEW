//
//  ConnectionStatusButton.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/7/28.
//  About LocalizedStringKey.toString() https://stackoverflow.com/questions/64429554/how-to-get-string-value-from-localizedstringkey

import SwiftUI

struct ConnectionStatusButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var monitor = NetworkMonitor()
    @State private var isConnectedToInternet = false
    var fontColor: Color {
        colorScheme == .light
        ? Color(hue: 1.0, saturation: 0.0, brightness: 0.167)
        : Color(hue: 1.0, saturation: 0.0, brightness: 0.833)
        
    }
    let fontSize = 16
    let todayStr = LocalizedStringKey("today-string").toString()
    var lastPingTime: Date
    var subtext: String
    
    init(lastPingTime: Date) {
        self.lastPingTime = lastPingTime
        let dateFormatter = DateFormatter()

        if Calendar.current.isDateInToday(lastPingTime) {
            dateFormatter.dateFormat = " HH:mm"
            self.subtext = todayStr + dateFormatter.string(from: lastPingTime)
        } else {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            self.subtext = dateFormatter.string(from: lastPingTime)
        }
    }
    
    var body: some View {
        VStack (alignment: .trailing) {
            if !monitor.isConnected {
                negativeConnection
            } else if (Date().timeIntervalSince(lastPingTime) < 65) {
                positive
            } else {
                negativeServer
            }
            Text(subtext)
                .font(.caption2)
        }
        .padding(.trailing, 30.0)
    }

    var positive: some View {
        NavigationLink {
            ConnectionStatusView()
        } label: {
            HStack {
                Circle().frame(width: CGFloat(fontSize)-3)
                    .foregroundColor(.green)
                Text("connected-string")
                    .font(Font.system(size: CGFloat(fontSize), design: .default).weight(.medium))
                    .foregroundColor(fontColor)
                    
            }
        }
    }
    var negativeServer: some View {
        NavigationLink {
            ConnectionStatusView()
        } label: {
            HStack {
                Circle().frame(width: CGFloat(fontSize)-3)
                    .foregroundColor(.yellow)
                Text("server-err-string")
                    .font(Font.system(size: CGFloat(fontSize), design: .default).weight(.medium))
                .foregroundColor(fontColor)
            }
        }
    }
    var negativeConnection: some View {
        NavigationLink {
            ConnectionStatusView()
        } label: {
            HStack {
                Circle().frame(width: CGFloat(fontSize)-3)
                    .foregroundColor(.red)
                Text("internet-err-string")
                    .font(Font.system(size: CGFloat(fontSize), design: .default).weight(.medium))
                .foregroundColor(fontColor)
            }
        }
    }
}

struct ConnectionStatusButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusButton(lastPingTime: Date())
    }
}

extension LocalizedStringKey {

    /**
     Return localized value of this LocalizedStringKey
     */
    public func toString() -> String {
        //use reflection
        let mirror = Mirror(reflecting: self)
        
        //try to find 'key' attribute value
        let attributeLabelAndValue = mirror.children.first { (arg0) -> Bool in
            let (label, _) = arg0
            if(label == "key"){
                return true;
            }
            return false;
        }
        
        if(attributeLabelAndValue != nil) {
            //ask for localization of found key via NSLocalizedString
            return String.localizedStringWithFormat(NSLocalizedString(attributeLabelAndValue!.value as! String, comment: ""));
        }
        else {
            return "Swift LocalizedStringKey signature must have changed. @see Apple documentation."
        }
    }
}
