//
//  LocationBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/16.
//

import SwiftUI

struct LocationBlock: View {
    var subscribedLoc: Location
    var locationCH = [
        Location.taipei : LocalizedStringKey("taipei-string"),
        Location.hsinchu : LocalizedStringKey("hsinchu-string") ,
        Location.taichung : LocalizedStringKey("taichung-string") ,
        Location.kaohsiung : LocalizedStringKey("kaohsiung-string") ,
        Location.pingtung : LocalizedStringKey("pingtung-string") ,
        Location.taitung : LocalizedStringKey("taitung-string") ,
        Location.hualian : LocalizedStringKey("hualian-string") ,
        Location.yilan : LocalizedStringKey("yilan-sttring") ,
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 100.0, height: 40.0)
                .clipped()
                .cornerRadius(15.0)
            Text(locationCH[subscribedLoc]!)
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
