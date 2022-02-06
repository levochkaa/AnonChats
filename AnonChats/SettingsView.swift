
import SwiftUI

struct SettingsView: View {

    @State var nickname = "Nickname"

    var body: some View {
        VStack {
            TextField("Nickname", text: $nickname)
            Button(action: {
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }) {
                Text("Logout")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.red)
            }
        }
    }
}
