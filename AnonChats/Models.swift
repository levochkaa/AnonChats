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
    @Published var query = 1
    private let firestore = Firestore.firestore()
    private let user = Auth.auth().currentUser

    func getSortedFilteredChats(query: String, sortedBy: Int) -> [Chat] {
        if query == "" && sortedBy == 1 {
            return chats
        } else if query == "" && sortedBy != 1 {
            return chats.filter { $0.maxUsers == sortedBy }
        } else if query != "" && sortedBy == 1 {
            return chats.filter { $0.title.lowercased().contains(query.lowercased()) }
        } else {
            let sortedChats = chats.filter { $0.title.lowercased().contains(query.lowercased()) }
            return sortedChats.filter { $0.maxUsers == sortedBy }
        }
    }

    func fetchData() {
        if user != nil {
            firestore.collection("chats").addSnapshotListener({(snapshot, _) in
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
                    return Chat(id: uid, title: title, topic: topic,
                                maxUsers: maxUsers, users: users, messages: messages)
                })
            })
        }
    }

    func createChat(title: String, topic: String, maxUsers: Int, handler: @escaping () -> Void) {
        if user != nil {
            firestore.collection("chats").addDocument(data: [
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
            firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments { (snapshot, error) in
                if let error = error {
                    print("error getting docs \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.firestore.collection("chats").document(document.documentID).updateData([
                            "users": FieldValue.arrayUnion([self.user!.uid])
                        ])
                        handler()
                    }
                }
            }
        }
    }
}

class FirebaseSession: ObservableObject {
    let auth = Auth.auth()

    func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, (error.localizedDescription))
                return
            }
            completion(true, (result?.user.email)!)
        }
    }

    func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, (error.localizedDescription))
                return
            }
            completion(true, (result?.user.email)!)
        }
    }
}
