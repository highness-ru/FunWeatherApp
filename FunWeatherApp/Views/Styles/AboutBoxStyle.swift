import SwiftUI

struct AboutBoxStyle: ViewModifier {
    var height: CGFloat = 700
    var maxWidth: CGFloat = 900
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            let isWideLayout = geo.size.width >= 700
            let boxWidth = isWideLayout
            ? min(geo.size.width * 0.62, maxWidth)
            : geo.size.width - 48
            
            let boxHeight = isWideLayout ? 300 : height
            
            content
                .padding(isWideLayout ? 28 : 22)
                .frame(width: boxWidth, height: boxHeight)
                .background(Color.black.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: height)
    }
}
