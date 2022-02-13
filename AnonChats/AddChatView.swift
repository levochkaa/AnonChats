import SwiftUI

struct AddChatView: View {

    @State var title = ""
    @State var topic = ""
    @State var maxN = 0
    @State private var maxNVars = [2, 3]
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: Chats

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Topic", text: $topic)
                Picker("Max number of people", selection: $maxN) {
                    ForEach(0..<maxNVars.count) {
                        Text("\(maxNVars[$0])")
                    }
                } .pickerStyle(.segmented)
            }
            .navigationTitle("Create a chat")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.createChat(title: title, topic: topic, maxUsers: maxNVars[maxN])
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Create")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct AddChatView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatView()
    }
}
