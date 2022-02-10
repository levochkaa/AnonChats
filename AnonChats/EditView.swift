import SwiftUI

struct EditView: View {

    @State private var maxNVars = [2, 3]
    @EnvironmentObject var viewModel: Chats
    @State var text = ""
    @State var select = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $text)
            }
            Section(header: Text("Topic")) {
                TextField("Topic", text: $text)
            }
            Section(header: Text("Max number of people")) {
                Picker("Max number of people", selection: $select) {
                    ForEach(0..<maxNVars.count) {
                        Text("\(maxNVars[$0])")
                    }
                } .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Edit")
        .safeAreaInset(edge: .top) {
            VStack(spacing: 0) {
                Color(red: 50/255, green: 50/255, blue: 50/255, opacity: 1)
                    .frame(height: CGFloat(1) / UIScreen.main.scale)
            } .background(.bar)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        }
    }
}
