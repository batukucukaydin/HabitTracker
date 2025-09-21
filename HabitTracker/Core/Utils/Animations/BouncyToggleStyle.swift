// -------------------------------------------------------------
// Core/Utils/Animations/BouncyToggleStyle.swift – custom toggle with icon fills
// -------------------------------------------------------------
import SwiftUI

struct BouncyToggleStyle: ToggleStyle {
    var icon: String
    var filledIcon: String

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? filledIcon : icon)
                .imageScale(.large)
                .scaleEffect(configuration.isOn ? 1.15 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isOn)
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.accentColor.opacity(0.8) : Color.gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .shadow(radius: 1)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                    Haptics.impact(.rigid)
                }
        }
        .padding(.vertical, 8)
    }
}

