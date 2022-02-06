
import SwiftUI

struct HomeView: View {

    @State var selectedTab: Tabs = .chats
    @State private var showAddChatView = false

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .none
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        NavigationView {
            switch selectedTab {
                case .favourite:
                    FavouriteView()
                        .navigationTitle("Favourite")
                case .chats:
                    ChatsView()
                        .navigationTitle("Chats")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { self.showAddChatView = true }) {
                                    Image(systemName: "plus")
                                } .sheet(isPresented: $showAddChatView) { AddChatView() }
                            }
                            ToolbarItem(placement: .navigationBarLeading) {
                                Menu {
                                    Button(action: {}) {
                                        HStack {
                                            Text("Default")
                                            Spacer()
                                            Image(systemName: "person.fill")
                                        }
                                    }
                                    Button(action: {}) {
                                        HStack {
                                            Text("By 2 people")
                                            Spacer()
                                            Image(systemName: "person.2.fill")
                                        }
                                    }
                                    Button(action: {}) {
                                        HStack {
                                            Text("By 3 people")
                                            Spacer()
                                            Image(systemName: "person.3.sequence.fill")
                                        }
                                    }
                                } label: {
                                    Button(action: {}) {
                                        Text("Sort")
                                    }
                                }
                            }
                        }
                case .settings:
                    SettingsView()
                        .navigationTitle("Settings")
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 100) {
                Button(action: { self.selectedTab = .favourite }) {
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
                Button(action: { self.selectedTab = .chats }) {
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
                Button(action: { self.selectedTab = .settings }) {
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
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, 10)
            .background(.bar)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
