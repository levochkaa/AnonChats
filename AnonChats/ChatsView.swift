import SwiftUI

struct ChatsView: View {
    
    @State private var query = ""
    @EnvironmentObject var viewModel: Chats
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserViewModel
    
    var body: some View {
        List(viewModel.getSortedFilteredChats(query: query)) { chat in
            NavigationLink(destination: ChatView(chat: chat).environmentObject(viewModel).environmentObject(appState).environmentObject(userModel)) {
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
            .contextMenu {
                Button(action: {
                    viewModel.addToFavourite(id: chat.id)
                }) {
                    Image(systemName: "star")
                    Text("Add to favourite")
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $query)
        .refreshable {
            viewModel.fetchData()
        }
    }
}
