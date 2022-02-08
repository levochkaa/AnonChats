
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

enum Tabs: String {
    case favourite
    case chats
    case settings
}

struct Message: Codable, Identifiable {
    var id: String
    var text: String
    var fromId: String
    var toId: String
}

struct User: Codable {
    var uid: String
    var username: String
    var favourite: [Chat]
}

struct Chat: Codable, Identifiable {
    var id: String
    var title: String
    var topic: String
    var maxUsers: Int
    var users: [String]
    var messages: [Message]
}

class Chats: ObservableObject {
    @Published var chats = [Chat]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser

    func fetchData() {
        if user != nil {
            db.collection("chats").addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no docs")
                    return
                }
                self.chats = documents.map({docSnapshot -> Chat in
                    let data = docSnapshot.data()
                    let uid = UUID().uuidString
                    let title = data["title"] as? String ?? "?"
                    let topic = data["topic"] as? String ?? "?"
                    let maxUsers = data["maxUsers"] as? Int ?? -1
                    let users = data["users"] as? [String] ?? []
                    let messages = data["messages"] as? [Message] ?? []
                    return Chat(id: uid, title: title, topic: topic, maxUsers: maxUsers, users: users, messages: messages)
                })
            })
        }
    }

    func createChat(title: String, topic: String, maxUsers: Int, handler: @escaping () -> Void) {
        if user != nil {
            db.collection("chats").addDocument(data: [
                "uid": UUID().uuidString,
                "title": title,
                "topic": topic,
                "maxUsers": maxUsers,
                "users": [user!.uid],
                "messages": []
            ]) { err in
                if let err = err {
                    print("error adding doc \(err)")
                } else {
                    handler()
                }
            }
        }
    }

    func joinChat(id: String, handler: @escaping () -> Void) {
        if user != nil {
            db.collection("chats").whereField("uid", isEqualTo: id).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting docs \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.db.collection("chats").document(document.documentID).updateData(["users": FieldValue.arrayUnion([self.user!.uid])])
                        handler()
                    }
                }
            }
        }
    }
}
