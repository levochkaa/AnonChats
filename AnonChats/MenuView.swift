import SwiftUI

struct MenuView: View {

    @EnvironmentObject var viewModel: Chats

    var body: some View {
        Menu {
            Button(action: {
                self.viewModel.query = 0
            }) {
                HStack {
                    Text("Open")
                    Spacer()
                    Image(systemName: "lock.open.fill")
                }
            }
            Button(action: {
                self.viewModel.query = 1
            }) {
                HStack {
                    Text("Default")
                    Spacer()
                    Image(systemName: "person.fill")
                }
            }
            Button(action: {
                self.viewModel.query = 2
            }) {
                HStack {
                    Text("By 2 people")
                    Spacer()
                    Image(systemName: "person.2.fill")
                }
            }
            Button(action: {
                self.viewModel.query = 3
            }) {
                HStack {
                    Text("By 3 people")
                    Spacer()
                    Image(systemName: "person.3.sequence.fill")
                }
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
