
import SwiftUI

struct ChatView: View {

    @State var text = ""
    @FocusState var isFocused: Bool
    @EnvironmentObject var viewModel: Chats
    @State private var messages = ["1", "2", "3", "4", "5", "6", "7",
                                       "8", "9", "10", "11", "12", "13", "14",
                                       "15", "16", "17", "18", "19", "20", "21",
                                       "22", "23", "24", "25", "26", "27", "28",
                                       "29", "30", "31", "32", "33", "34", "35",
                                       "36", "37", "38", "39", "40", "41", "42",
                                       "43", "44", "45", "46", "47", "48", "49"]

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack {
                    ForEach(messages, id:\.self) { message in
                        HStack {
                            Spacer()
                            Text(message)
                                .background(.pink)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(.white, lineWidth: 1))
                            Spacer()
                        }
                        .id(message)
                    }
                }
                .id("end")
                .onChange(of: isFocused) { _ in
                    if isFocused {
                        withAnimation {
                            scrollView.scrollTo("end", anchor: .bottom)
                        }
                    }
                }
            }
            .onChange(of: messages) { _ in
                withAnimation {
                    scrollView.scrollTo("end", anchor: .bottom)
                }
            }
            .onAppear {
                scrollView.scrollTo("end", anchor: .bottom)
            }
            .onTapGesture {
                self.isFocused = false
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    MultilineTextField("Message", text: self.$text)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white, lineWidth: 1)
                                    .padding(.leading, 10))
                        .focused($isFocused)
                    Button(action: {
                        if text != "" {
                            self.messages.append(text)
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
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    Color(red: 50/255, green: 50/255, blue: 50/255)
                        .frame(height:CGFloat(1) / UIScreen.main.scale)
                    HStack(alignment: .center) {
                        Text("1/2")
                        Spacer()
                        Text("topic")
                            .padding(.vertical, 5)
                        Spacer()
                        Image(systemName: "repeat")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .padding(.horizontal, 20)
                    .background(.bar)
                    Color(red: 50/255, green: 50/255, blue: 50/255)
                        .frame(height:CGFloat(1) / UIScreen.main.scale)
                }
            }
        }
        .navigationBarTitle("name", displayMode: .inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
