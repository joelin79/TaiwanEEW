//
//  ConnectionStatusButton.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/7/28.
//

import SwiftUI

struct ConnectionStatusButton: View {
    var body: some View {
        VStack {
            positive
        }
    }

    var positive: some View {
        Form {
            NavigationLink {
                ConnectionStatusView()
            } label: {
                HStack {
                    Circle().frame(width: 15)
                        .foregroundColor(.green)
                    Text("伺服器端異常")
                    .font(Font.system(size: 20, design: .default).weight(.medium))
                }
            }
        }
    }
    var negativeServer: some View {
        Form {
            NavigationLink {
                ConnectionStatusView()
            } label: {
                HStack {
                    Circle().frame(width: 15)
                        .foregroundColor(.green)
                    Text("伺服器端異常")
                    .font(Font.system(size: 20, design: .default).weight(.medium))
                }
            }
        }
    }
    var negativeConnection: some View {
        Form {
            NavigationLink {
                ConnectionStatusView()
            } label: {
                HStack {
                    Circle().frame(width: 15)
                        .foregroundColor(.green)
                    Text("伺服器端異常")
                    .font(Font.system(size: 20, design: .default).weight(.medium))
                }
            }
        }
    }
}

struct ConnectionStatusButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusButton()
    }
}
