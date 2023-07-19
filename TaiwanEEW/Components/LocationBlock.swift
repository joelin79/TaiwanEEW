//
//  LocationBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/16.
//

import SwiftUI

struct LocationBlock: View {
    var subscribedLoc: Location
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 100.0, height: 40.0)
                .clipped()
                .cornerRadius(15.0)
            Text(subscribedLoc.getDisplayName())
                .foregroundColor(Color("Pad"))
                .font(Font.system(size: 20, design: .default).weight(.medium))
        }
        
    }
    
}

//struct LocationBlock_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationBlock()
//    }
//}
