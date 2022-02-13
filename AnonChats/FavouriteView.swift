import SwiftUI

struct FavouriteView: View {

    @State var isActive: Bool = false
    @State private var query = ""
    @EnvironmentObject var viewModel: Chats

    var body: some View {
        List(viewModel.getFavouriteFilteredChats(query: query)) { chat in
            NavigationLink(destination: ChatView(chat: chat, chats: viewModel, rootIsActive: self.$isActive), isActive: self.$isActive) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(chat.title)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Text(chat.topic)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                    }
                    Spacer()
                    Text("\(chat.users.count)/\(chat.maxUsers)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } .padding(.vertical, 10)
            }
            .isDetailLink(false)
            .contextMenu {
                Button(action: {
                    viewModel.removeFromFavourite(id: chat.id)
                }) {
                    Image(systemName: "star")
                    Text("Remove from favourite")
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
