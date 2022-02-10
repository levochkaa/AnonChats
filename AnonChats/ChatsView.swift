import SwiftUI

struct ChatsView: View {

    @State private var query = ""
    @EnvironmentObject var viewModel: Chats

    var body: some View {
        List(viewModel.getSortedFilteredChats(query: query, sortedBy: viewModel.query)) { chat in
            NavigationLink(destination: ChatView().environmentObject(viewModel)) {
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
        }
        .padding(.top, -10)
        .searchable(text: $query)
        .listStyle(.plain)
        .refreshable {
            viewModel.fetchData()
        }
    }
}
