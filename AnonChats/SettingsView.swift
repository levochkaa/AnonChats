import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var firebase: FirebaseSession
    @EnvironmentObject var userModel: UserViewModel

    var body: some View {
        Form {
            Section(header: Text("Username")) {
                TextField("Username", text: $userModel.userModel.first!.username)
                Button(action: {
                    userModel.setUser(username: userModel.userModel.first!.username)
                }) {
                    Text("Save")
                }
            }
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
                    .foregroundColor(.red)
            }
        }
    }
}
