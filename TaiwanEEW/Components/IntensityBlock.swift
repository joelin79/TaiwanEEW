//
//  IntensityBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/8/18.
//

import SwiftUI

struct IntensityBlock: View {
    var intensity: String
    
    // Container
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("Pad"))
                .frame(width: 170, height: 170)
                .clipped()
                .overlay(content)
        }
        
    }
    
    // Content inside container
    var content: some View {
        Group {
            VStack{
                Text("intensity-string")
                    .font(Font.system(.largeTitle, design: .default).weight(.medium))
                HStack(alignment: .bottom){
                    Text(intensity)
                        .font(.system(size: 80, weight: .bold, design: .monospaced)).foregroundColor(Color(intensity))
                    // TODO: Fix the subscript translation
//                    if !"intensity-sub-string".isEmpty {
                        Text(String(localized:"intensity-sub-string"))
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
//                    }
                }
                
            }
        }
    }
}

struct IntensityBlock_Previews: PreviewProvider {
    static var previews: some View {
        IntensityBlock(intensity: "4").environment(\.locale, Locale.init(identifier: "en"))
        IntensityBlock(intensity: "4").environment(\.locale, Locale.init(identifier: "zh-Hant"))
    }
}
