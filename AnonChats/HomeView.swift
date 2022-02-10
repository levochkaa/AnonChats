import SwiftUI

struct HomeView: View {

    @State var selectedTab: Tabs = .chats
    @State private var showAddChatView = false
    @ObservedObject var viewModel = Chats()
    @ObservedObject var firebase = FirebaseSession()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .none
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        viewModel.fetchData()
    }

    var body: some View {
        NavigationView {
            VStack {
                switch selectedTab {
                case .favourite:
                        FavouriteView()
                            .navigationTitle("Favourite")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    EditButton()
                                }
                            }
                case .chats:
                        ChatsView()
                            .environmentObject(viewModel)
                            .navigationTitle("Chats")
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
                            .navigationTitle("Settings")
                }
                Spacer()
                HStack(spacing: 100) {
                    Button(action: {
                        self.selectedTab = .favourite
                    }) {
                        VStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == .favourite ? .accentColor : .gray)
                            Text("Favourite")
                                .font(.system(size: 10, weight: .regular, design: .rounded))
                                .foregroundColor(selectedTab == .favourite ? .accentColor : .gray)
                        }
                    }
                    Button(action: {
                        self.selectedTab = .chats
                    }) {
                        VStack {
                            Image(systemName: "message.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == .chats ? .accentColor : .gray)
                            Text("Chats")
                                .font(.system(size: 10, weight: .regular, design: .rounded))
                                .foregroundColor(selectedTab == .chats ? .accentColor : .gray)
                        }
                    }
                    Button(action: {
                        self.selectedTab = .settings
                    }) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedTab == .settings ? .accentColor : .gray)
                            Text("Settings")
                                .font(.system(size: 10, weight: .regular, design: .rounded))
                                .foregroundColor(selectedTab == .settings ? .accentColor : .gray)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .bottom)
                .background(.bar)
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    Color(red: 50/255, green: 50/255, blue: 50/255, opacity: 1)
                        .frame(height: CGFloat(1) / UIScreen.main.scale)
                } .background(.bar)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
