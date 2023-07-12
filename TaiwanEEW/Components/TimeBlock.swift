//
//  TimeBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/8/18.
//

import SwiftUI

struct TimeBlock: View {
    var arrivalTime: Date
    
    @State private var text: String = ""
    func calcEstTime () -> Int {
        return -Int(Date().timeIntervalSince(arrivalTime))
    }
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color("Pad"))
            .frame(width: 170, height: 170)
            .clipped()
            .overlay(
                VStack{
                    Text("arrival-string")
                        .font(Font.system(.largeTitle, design: .default).weight(.medium))
                    HStack(alignment: .bottom){
                        Text( (calcEstTime()>0) ? String(text) : "0")
                            .font(.system(size: (calcEstTime()>99) ? 50 : 80, weight: .bold, design: .monospaced))
                            .onReceive(
                                Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
                                perform: { _ in
                                    self.text = String(calcEstTime())
                                }
                            )
                        Text("seconds-string")
                            .font(.system(size: 30, weight: .bold, design: .monospaced ))
                    }
                }
            )
    }
}

struct TimeBlock_Previews: PreviewProvider {
    static var previews: some View {
        TimeBlock(arrivalTime: Date())
    }
}
