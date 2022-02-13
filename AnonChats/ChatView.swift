
import SwiftUI

struct ChatView: View {

    let chat: Chat
    let chats: Chats
    var rootIsActive: Binding<Bool>
    @State var text = ""
    @FocusState var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel = Messages()

    init(chat: Chat, chats: Chats, rootIsActive: Binding<Bool>) {
        self.chat = chat
        self.chats = chats
        self.rootIsActive = rootIsActive
        self.chats.joinChat(id: chat.id)
        viewModel.fetchData(docId: chat.id)
    }

    var body: some View {
        ZStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                Text(message.text)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                        .background(message.fromId == message.toId ? .green : .blue))
                            .id(message.id)
                        }
                    }
                    .padding(.bottom, 55)
                    .id("end")
                }
                .onAppear {
                    scrollView.scrollTo("end", anchor: .bottom)
                }
                .onTapGesture {
                    self.isFocused = false
                }
                .onChange(of: viewModel.messages) { _ in
                    withAnimation {
                        scrollView.scrollTo("end", anchor: .bottom)
                    }
                }
                .onChange(of: isFocused) { _ in
                    if isFocused {
                        withAnimation {
                            scrollView.scrollTo("end", anchor: .bottom)
                        }
                    }
                }
            }
            HStack {
                MultilineTextField("Message", text: self.$text)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .padding(.leading, 15)
                    .padding(.trailing, 5)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
                                .padding(.leading, 10)
                                .padding(.vertical, 4))
                    .focused($isFocused)
                Button(action: {
                    if text != "" {
                        viewModel.sendMessage(message: Message(id: chat.id, text: text, fromId: viewModel.user!.uid, toId: chat.id), docId: chat.id)
                        self.text = ""
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue)
                        .padding(.trailing, 10)
                }
            }
            .padding(.vertical, 5)
            .background(.bar)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarTitle(chat.title, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditView(chat: chat, shouldPopToRootView: self.rootIsActive).environmentObject(viewModel)) {
                    Text("Edit")
                } .isDetailLink(false)
            }
            ToolbarItem(placement: .principal) {
                VStack(alignment: .center, spacing: 0) {
                    Text(chat.title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                    Text(chat.topic)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
