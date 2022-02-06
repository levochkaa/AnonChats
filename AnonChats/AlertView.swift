
import SwiftUI

struct AlertView: View {

    @State var message: String
    @Binding var show: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()
            VStack(spacing: 10) {
                Text("Error")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                Text(message)
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                Button(action: {
                    withAnimation {
                        self.show.toggle()
                    }
                }) {
                    Text("OK")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                }
            }
            .frame(width: UIScreen.main.bounds.width - 70)
            .padding()
            .background()
            .cornerRadius(20)
        }
    }
}
