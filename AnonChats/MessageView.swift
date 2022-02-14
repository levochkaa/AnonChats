import SwiftUI

struct MessageView: View {

    @State var message: Message
    @State var toId: String

    var body: some View {
        VStack(alignment: message.fromId == self.toId ? .trailing : .leading, spacing: 0) {
            VStack(alignment: message.fromId == self.toId ? .trailing : .leading, spacing: 0) {
                if message.fromId != self.toId {
                    Text(message.username)
                        .multilineTextAlignment(message.fromId == self.toId ? .trailing : .leading)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 7, leading: 7, bottom: 0, trailing: 7))
                }
                Text(message.text)
                    .padding(EdgeInsets(top: message.fromId == self.toId ? 7 : 0, leading: 7, bottom: 7, trailing: 7))
            }
            .padding(3)
            .background(message.fromId == self.toId ? .blue : Color(red: 30/255, green: 30/255, blue: 30/255))
            .cornerRadius(20)
            .frame(maxWidth: 300, alignment: message.fromId == self.toId ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity, alignment: message.fromId == self.toId ? .trailing : .leading)
        .padding(message.fromId == self.toId ? .trailing : .leading)
        .padding(.horizontal, 5)
        .id(message.id)
    }
}
