
import SwiftUI

struct MainView: View {

    @State private var showAuth = false
    @State private var showReg = false
    @ObservedObject var firebase = FirebaseSession()
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
                Text("Hi! This app is made to find people for communication. Click a button below to proceed. Happy messaging!")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Button(action: {
                    self.showAuth = true
                }) {
                    Text("Sign in")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 120)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                } .sheet(isPresented: $showAuth) {
                    AuthorizationView()
                        .environmentObject(firebase)
                }
                Button(action: {
                    self.showReg = true
                }) {
                    Text("Sign up")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 117)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                } .sheet(isPresented: $showReg) {
                    RegistrationView()
                        .environmentObject(firebase)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
