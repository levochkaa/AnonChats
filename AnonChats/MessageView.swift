import SwiftUI

struct MessageView: View {

    @State var message: Message
    @State var toId: String

    var body: some View {
        VStack(alignment: message.fromId == self.toId ? .trailing : .leading, spacing: 0) {
            HStack {
                Text(message.text)
                    .padding(7)
                    .background(message.fromId == self.toId ? .blue : .green)
                    .cornerRadius(20)
            } .frame(maxWidth: 300, alignment: message.fromId == self.toId ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity, alignment: message.fromId == self.toId ? .trailing : .leading)
        .padding(message.fromId == self.toId ? .trailing : .leading)
        .padding(.horizontal, 5)
        .id(message.id)
    }
}
