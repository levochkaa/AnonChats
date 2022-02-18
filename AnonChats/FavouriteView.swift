import SwiftUI

struct FavouriteView: View {

    @State private var query = ""
    @EnvironmentObject var viewModel: Chats
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserViewModel

    var body: some View {
        List(viewModel.getFavouriteFilteredChats(query: query)) { chat in
            NavigationLink(destination: ChatView(chat: chat).environmentObject(viewModel).environmentObject(appState)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(chat.title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                        Text(chat.topic)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .lineLimit(1)
                    }
                    Spacer()
                    Text("\(chat.users.count)/\(chat.maxUsers)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } .padding(.vertical, 10)
            }
            .disabled(chat.maxUsers == chat.users.count && !chat.users.contains(viewModel.user!.uid))
            .contextMenu {
                Button(action: {
                    viewModel.removeFromFavourite(id: chat.id)
                }) {
                    Image(systemName: "star")
                    Text("Remove from favourite")
                }
            }
        }
        .onAppear {
            userModel.fetchUser()
        }
        .listStyle(.plain)
        .searchable(text: $query)
        .refreshable {
            viewModel.fetchData()
        }
    }
}
