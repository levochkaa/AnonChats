import SwiftUI

struct MenuView: View {

    @EnvironmentObject var viewModel: Chats

    var body: some View {
        Menu {
            Button(action: {
                self.viewModel.query = 0
            }) {
                Text("Open")
                Image(systemName: "lock.open.fill")
            }
            Button(action: {
                self.viewModel.query = 1
            }) {
                Text("Default")
                Image(systemName: "person.fill")
            }
            Button(action: {
                self.viewModel.query = 2
            }) {
                Text("By 2 people")
                Image(systemName: "person.2.fill")
            }
            Button(action: {
                self.viewModel.query = 3
            }) {
                Text("By 3 people")
                Image(systemName: "person.3.sequence.fill")
            }
        } label: {
            Button(action: {
                //
            }) {
                Text("Sort")
            }
        }
    }
}
