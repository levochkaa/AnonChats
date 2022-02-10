import SwiftUI

struct SettingsView: View {

    @State var username = "Username"
    @EnvironmentObject var firebase: FirebaseSession
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Text("Your username:")
                .font(.largeTitle)
                .padding(.bottom)
            TextField("Username", text: $username)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
                .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                .padding(.horizontal, 30)
            Spacer()
            Button(action: {
                do {
                    try firebase.auth.signOut()
                } catch {
                    print("didn't signOut")
                }
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }) {
                Text("Logout")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.red)
                    .padding(.vertical)
                    .padding(.horizontal, 150)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.red, lineWidth: 2))
            }
            .padding(.bottom, 70)
        }
    }
}
