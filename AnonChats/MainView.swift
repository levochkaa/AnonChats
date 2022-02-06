
import SwiftUI

struct MainView: View {

    @State private var showAuth = false
    @State private var showReg = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .center) {
            Image("Fox")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .opacity(0.3)
            VStack(alignment: .center, spacing: 20) {
                Text("AnonChats")
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nisl condimentum id venenatis a.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Button(action: { self.showAuth.toggle() }) {
                    Text("Sign in")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 120)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                } .sheet(isPresented: $showAuth) { AuthorizationView() }
                Button(action: { self.showReg.toggle() }) {
                    Text("Sign up")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 117)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                } .sheet(isPresented: $showReg) { RegistrationView() }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
