//
//  AlertStatusBar.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/18.
//

import SwiftUI

struct AlertStatusBar : View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var arrivalTime: Date
    var intensity: String
    @State private var opacity: Double = 1
    @State private var fillColor: Color = .green
    @State private var isAlert: Bool = false
    @State private var isMajor: Bool = false
    @State private var isUpdated: Bool = false     // used to indicate if arrivalTime is updated to non-default value (1970/1/1)
    
    var strLocL = NSLocalizedString("loading-string", comment: "")
    var strLoc1 = NSLocalizedString( "alert-status-1-string", comment: "")
    var strLoc2 = NSLocalizedString( "alert-status-2-string", comment: "")
    var strLoc3 = NSLocalizedString( "alert-status-3-string", comment: "")
    
    var body: some View {
        Rectangle()
        // Color
            .fill( (isUpdated) ? (isAlert) ? (isMajor) ? Color.red : Color.yellow : Color.green : Color.gray)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
            .frame(width:
                    UIScreen.baseLine+340,
                   height: 50.0)
            .clipped()
            .overlay(
        // Text
                StrokeText(text: (isUpdated) ? (isAlert) ? (isMajor) ? strLoc3 : strLoc2 : strLoc1 : strLocL , width: (isMajor) ? 0.75 : 0 , color: .black)
                    .foregroundColor( (isMajor) ? .white : .black)
                    .font(.system(size: 28).bold().monospaced())
        // Opacity Animation
            ).opacity(opacity)
            .onReceive(timer) { _ in
                updateAlert()
                print("[update] last arrival: \(arrivalTime.formatted())")
            }
            .onAppear {
                updateAlert()
            }
            
    }

    private func updateAlert() {
        
        // updates isInAlert (true before 10 seconds after wave arrival
        let now = Date()
        let isInAlert = now.addingTimeInterval(TimeInterval(0-10)) < arrivalTime
        if isInAlert != isAlert {
            isAlert = isInAlert
            if isAlert {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
        
        // updates isUpdate
        if arrivalTime > Date(timeIntervalSince1970: 1000){
            isUpdated = true
        } else {
            isUpdated = false       // Note: AlertView defaults arrivalTime value to 1970/1/1 before firebase is connected
        }
        
        // updates isMajor
        if (isAlert && intensity.first!.wholeNumberValue! >= 4 ) {
            isMajor = true
        } else {
            isMajor = false
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.1).delay(0.25).repeatForever()) {
                opacity = 0.5
            }
        }

    private func stopAnimation() {
        withAnimation (.linear(duration: 0.1)){
            opacity = 1.0
        }
    }
    
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

struct AlertStatusBar_Preview : PreviewProvider {
    static var previews: some View {
        AlertStatusBar(arrivalTime: Date(), intensity: "5-").environment(\.locale, Locale.init(identifier: "zh-Hant"))
    }
    
}
