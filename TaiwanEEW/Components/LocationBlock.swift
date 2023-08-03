//
//  LocationBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/16.
//

import SwiftUI

struct LocationBlock: View {
    var subscribedLoc: Location
    @State var blockWidth: CGFloat = 100
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .frame(width: blockWidth, height: 45.0)
                .clipped()
                .cornerRadius(15.0)
            Text(subscribedLoc.getDisplayName())
                .font(Font.system(size: 20, design: .default).weight(.medium))
                .foregroundColor(Color(.systemGray6))
                .overlay(
                    GeometryReader { geometry in
                    Text(subscribedLoc.getDisplayName())
                            .font(Font.system(size: 20, design: .default).weight(.medium))
                            .foregroundColor(Color(.systemGray6))
                        .onAppear {
                            blockWidth = geometry.size.width + 30
                        }
                }
                )
        }
        
    }
    
}

struct LocationBlock_Previews: PreviewProvider {
    static var previews: some View {
        LocationBlock(subscribedLoc: .taipei)
    }
}
