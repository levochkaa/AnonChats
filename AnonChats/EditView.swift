import SwiftUI

struct EditView: View {

    @State var chat: Chat
    @State private var maxNVars = [2, 3]
    @State var select = 0
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: Messages
    @EnvironmentObject var chats: Chats
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $chat.title)
            }
            Section(header: Text("Topic")) {
                TextField("Topic", text: $chat.topic)
            }
            Section(header: Text("Max number of people")) {
                Picker("Max number of people", selection: $select) {
                    ForEach(0..<maxNVars.count) {
                        Text("\(maxNVars[$0])")
                    }
                } .pickerStyle(.segmented)
            } .onChange(of: self.select) { _ in
                self.chat.maxUsers = maxNVars[select]
            }
            Section(header: Text("Bad things")) {
                Button(action: {
                    appState.rootViewId = UUID()
                    chats.removeFromFavourite(id: chat.id)
                }) {
                    Text("Remove from favourite")
                        .foregroundColor(.red)
                }
                Button(action: {
                    chats.leaveChat(id: chat.id)
                    chats.removeFromFavourite(id: chat.id)
                    appState.rootViewId = UUID()
                }) {
                    Text("Leave the chat")
                        .foregroundColor(.red)
                }
                Button(action: {
                    chats.deleteChat(id: chat.id)
                    appState.rootViewId = UUID()
                }) {
                    Text("Delete the chat")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Edit", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.updateData(id: chat.id, title: chat.title, topic: chat.topic, maxUsers: chat.maxUsers)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        }
    }
}
