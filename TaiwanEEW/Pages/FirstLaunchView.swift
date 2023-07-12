//
//  FirstLaunchView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/6/8.
//

import SwiftUI

struct FirstLaunchView: View {
    
    var onDismiss: () -> Void
    // MARK: https://medium.com/@yeeedward/bullet-list-with-swiftui-7dfb7e3c30f1
    var listItems = [
        NSLocalizedString("term1-string", comment: ""),
        NSLocalizedString("term2-string", comment: ""),
        NSLocalizedString("term3-string", comment: ""),
        NSLocalizedString("term4-string", comment: "")
    ]
    var listItemSpacing: CGFloat? = 18
    var toNumber: ((Int) -> String) = { "\($0 + 1)." }
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    var fontSize: CGFloat = 20
    
    var body: some View {
        VStack {
            icon
            title
            content
            close
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
        .background(.white)
        .transition(.move(edge: .bottom))
        
    }
}

struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView(onDismiss: {})
            .environment(\.locale, .init(identifier: "zh-Hant"))
        FirstLaunchView(onDismiss: {})
            .environment(\.locale, .init(identifier: "en"))
        FirstLaunchView(onDismiss: {})
            .environment(\.locale, .init(identifier: "jp"))
    }
}


private extension FirstLaunchView {
    var icon: some View {
        Image(systemName: "rectangle.inset.filled.and.person.filled")
            .font(.system(size: 50))
            .foregroundColor(Color.blue)
    }
    
    var title: some View {
        Text("term-title-string")
            .font(
                .system(size: 45, weight: .bold, design: .rounded))
            .padding(.top, 25)
    }
    
    // MARK: https://medium.com/@yeeedward/bullet-list-with-swiftui-7dfb7e3c30f1

    var content: some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems.indices, id: \.self) { idx in
                HStack(alignment: .top) {
                    Text(toNumber(idx))
                        .font(.system(size: fontSize))
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                    Text(listItems[idx])
                        .font(.system(size: fontSize))
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
            }
        }
               .padding(.top, 20)
    }

//    var close: some View {
//        Button {
//            onDismiss()
//        } label: {
//            Text("dismiss-string")
//                .font(.system(size: 20, weight: .bold))
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .foregroundColor(.white)
//        .background(.blue)
//        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//        .padding(.top, 50)
//    }
    
    var close: some View {
        Button(action: {
            onDismiss()
        }) {
            Text("dismiss-string")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.top, 50)
        }
    }

//    var background: some View {
//        RoundedCorners(color: .white, tl: 15, tr: 15, bl: 0, br: 0)
//            .shadow(color: .black.opacity(0.2), radius: 3)
//    }

}

//// MARK: https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
//struct RoundedCorners: View {
//    var color: Color = .blue
//    var tl: CGFloat = 0.0
//    var tr: CGFloat = 0.0
//    var bl: CGFloat = 0.0
//    var br: CGFloat = 0.0
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//
//                let w = geometry.size.width
//                let h = geometry.size.height
//
//                // Make sure we do not exceed the size of the rectangle
//                let tr = min(min(self.tr, h/2), w/2)
//                let tl = min(min(self.tl, h/2), w/2)
//                let bl = min(min(self.bl, h/2), w/2)
//                let br = min(min(self.br, h/2), w/2)
//
//                path.move(to: CGPoint(x: w / 2.0, y: 0))
//                path.addLine(to: CGPoint(x: w - tr, y: 0))
//                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
//                path.addLine(to: CGPoint(x: w, y: h - br))
//                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
//                path.addLine(to: CGPoint(x: bl, y: h))
//                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
//                path.addLine(to: CGPoint(x: 0, y: tl))
//                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
//                path.closeSubpath()
//            }
//            .fill(self.color)
//        }
//    }
//}
