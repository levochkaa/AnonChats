
import SwiftUI
import Firebase

@main
struct AnonChatsApp: App {
    init() { FirebaseApp.configure() }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
