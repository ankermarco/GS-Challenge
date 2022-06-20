import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}
