import SwiftUI

struct HomeView: View {

    @State var selectedTab: Tabs = .chats
    @State private var showAddChatView = false
    @ObservedObject var viewModel = Chats()
    @ObservedObject var firebase = FirebaseSession()
    @ObservedObject var userModel = UserViewModel()

    init() {
        viewModel.fetchData()
    }

    var body: some View {
        NavigationView {
            ZStack {
                switch selectedTab {
                    case .favourite:
                        FavouriteView()
                            .environmentObject(viewModel)
                            .navigationBarTitle("Favourite", displayMode: .large)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    EditButton()
                                }
                            }
                    case .chats:
                        ChatsView()
                            .environmentObject(viewModel)
                            .navigationBarTitle("Chats", displayMode: .large)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        self.showAddChatView = true
                                    }) {
                                        Image(systemName: "plus")
                                    } .sheet(isPresented: $showAddChatView) {
                                        AddChatView().environmentObject(viewModel)
                                    }
                                }
                                ToolbarItem(placement: .navigationBarLeading) {
                                    MenuView().environmentObject(viewModel)
                                }
                            }
                    case .settings:
                        SettingsView()
                            .environmentObject(firebase)
                            .environmentObject(userModel)
                            .navigationBarTitle("Settings", displayMode: .large)
                    }
                HStack(spacing: 110) {
                    Button(action: {
                        self.selectedTab = .favourite
                    }) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(selectedTab == .favourite ? .accentColor : .gray)
                    }
                    Button(action: {
                        self.selectedTab = .chats
                    }) {
                        Image(systemName: "message.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(selectedTab == .chats ? .accentColor : .gray)
                    }
                    Button(action: {
                        self.selectedTab = .settings
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(selectedTab == .settings ? .accentColor : .gray)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 70)
                .background(.bar)
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
