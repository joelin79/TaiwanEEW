//
//  InformationView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/7/12.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("mechanics-title-string")
                    .font(.headline)
                    .padding(.bottom, 2)
                    .foregroundColor(.blue)
                Text("mechanics-string")
            }
            VStack(alignment: .leading) {
                Text("sources-title-string")
                    .font(.headline)
                    .padding(.bottom, 2)
                    .padding(.top, 3)
                    .foregroundColor(.blue)
                Text("sources-string")
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
