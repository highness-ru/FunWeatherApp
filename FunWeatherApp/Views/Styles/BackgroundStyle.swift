import SwiftUI

struct BackgroundStyle: ViewModifier {
    let imageName: String

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
    }
}

extension View {
    func screenBackground(_ imageName: String) -> some View {
        self.modifier(BackgroundStyle(imageName: imageName))
    }
}
