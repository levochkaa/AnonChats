import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

enum Tabs: String {
    case favourite
    case chats
    case settings
}

class AppState : ObservableObject {
    @Published var rootViewId = UUID()
}

struct Message: Codable, Identifiable, Equatable {
    var id: String
    var text: String
    var fromId: String
}

class Messages: ObservableObject {
    @Published var messages = [Message]()
    let user = Auth.auth().currentUser
    private let firestore = Firestore.firestore()

    func updateData(id: String, title: String, topic: String, maxUsers: Int) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments { (snapshot, error) in
            if let error = error {
                print("error getting docs \(error)")
            } else {
                let document = snapshot!.documents.first
                document?.reference.updateData([
                    "title": title,
                    "topic": topic,
                    "maxUsers": maxUsers
                ])
            }
        }
    }

    func deleteChat(id: String) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments {(snapshot, _) in
            for document in snapshot!.documents {
                let docId = document.documentID
                self.firestore.collection("chats").document(docId).delete()
            }
        }
    }

    func sendMessage(message: Message) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: message.id).getDocuments {(snapshot, _) in
            for document in snapshot!.documents {
                let docId = document.documentID
                self.firestore.collection("chats").document(docId).collection("messages").addDocument(data: [
                    "sentAt": Date(),
                    "id": message.id,
                    "text": message.text,
                    "fromId": message.fromId
                ])
            }
        }

    }

    func fetchData(id: String) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments {(snapshot, _) in
            for document in snapshot!.documents {
                let docId = document.documentID
                self.firestore.collection("chats").document(docId).collection("messages").order(by: "sentAt", descending: false).addSnapshotListener({(snapshot, _) in
                    self.messages = snapshot!.documents.map { docSnapshot -> Message in
                        let data = docSnapshot.data()
                        let docId = docSnapshot.documentID
                        let text = data["text"] as? String ?? ""
                        let fromId = data["fromId"] as? String ?? ""
                        return Message(id: docId, text: text, fromId: fromId)
                    }
                })
            }
        }
    }
}

struct Chat: Codable, Identifiable {
    var id: String
    var title: String
    var topic: String
    var maxUsers: Int
    var users: [String]
    var favourite: [String]
}

class Chats: ObservableObject {
    @Published var chats = [Chat]()
    @Published var favouriteChats = [Chat]()
    @Published var query = 1
    let user = Auth.auth().currentUser
    private let firestore = Firestore.firestore()

    func getSortedFilteredChats(query: String) -> [Chat] {
        if query == "" && self.query == 1 {
            return chats
        } else if query == "" && self.query != 1 {
            return chats.filter { $0.maxUsers == self.query }
        } else if query != "" && self.query == 1 {
            return chats.filter { $0.title.lowercased().contains(query.lowercased()) }
        } else {
            let sortedChats = chats.filter { $0.title.lowercased().contains(query.lowercased()) }
            return sortedChats.filter { $0.maxUsers == self.query }
        }
    }

    func getFavouriteFilteredChats(query: String) -> [Chat] {
        if query == "" {
            return favouriteChats
        } else {
            return favouriteChats.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }

    func addToFavourite(id: String) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments { (snapshot, _) in
            for document in snapshot!.documents {
                self.firestore.collection("chats").document(document.documentID).updateData([
                    "favourite": FieldValue.arrayUnion([self.user!.uid])
                ])
            }
        }
    }

    func removeFromFavourite(id: String) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments { (snapshot, _) in
            for document in snapshot!.documents {
                self.firestore.collection("chats").document(document.documentID).updateData([
                    "favourite": FieldValue.arrayRemove([self.user!.uid])
                ])
            }
        }
    }

    func fetchData() {
        self.firestore.collection("chats").whereField("favourite", arrayContains: user!.uid).addSnapshotListener {(snapshot, _) in
            self.favouriteChats = snapshot!.documents.map({docSnapshot -> Chat in
                let data = docSnapshot.data()
                let uid = data["uid"] as? String ?? "?"
                let title = data["title"] as? String ?? "?"
                let topic = data["topic"] as? String ?? "?"
                let maxUsers = data["maxUsers"] as? Int ?? -1
                let users = data["users"] as? [String] ?? []
                let favourite = data["favourite"] as? [String] ?? []
                return Chat(id: uid, title: title, topic: topic, maxUsers: maxUsers, users: users, favourite: favourite)
            })
        }

        self.firestore.collection("chats").addSnapshotListener({(snapshot, _) in
            self.chats = snapshot!.documents.map({docSnapshot -> Chat in
                let data = docSnapshot.data()
                let uid = data["uid"] as? String ?? "?"
                let title = data["title"] as? String ?? "?"
                let topic = data["topic"] as? String ?? "?"
                let maxUsers = data["maxUsers"] as? Int ?? -1
                let users = data["users"] as? [String] ?? []
                let favourite = data["favourite"] as? [String] ?? []
                return Chat(id: uid, title: title, topic: topic, maxUsers: maxUsers, users: users, favourite: favourite)
            })
        })
    }

    func createChat(title: String, topic: String, maxUsers: Int) {
        self.firestore.collection("chats").addDocument(data: [
            "uid": UUID().uuidString,
            "title": title,
            "topic": topic,
            "maxUsers": maxUsers,
            "users": [user!.uid],
            "favourite": []
        ])
    }

    func joinChat(id: String) {
        self.firestore.collection("chats").whereField("uid", isEqualTo: id).getDocuments { (snapshot, _) in
            for document in snapshot!.documents {
                self.firestore.collection("chats").document(document.documentID).updateData([
                    "users": FieldValue.arrayUnion([self.user!.uid])
                ])
            }
        }
    }
}

struct User: Codable, Equatable {
    var uid: String
    var username: String
}

class UserViewModel: ObservableObject {
    @Published var userModel = [User]()
    let user = Auth.auth().currentUser
    private let firestore = Firestore.firestore()

    init() {
        self.fetchUser()
    }

    func fetchUser() {
        self.firestore.collection("users").whereField("uid", isEqualTo: user!.uid).getDocuments { (snapshot, _) in
            print(snapshot!.documents)
            for document in snapshot!.documents {
                let data = document.data()
                let uid = data["uid"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                self.userModel.append(User(uid: uid, username: username))
            }
        }
    }

    func setUser(username: String) {
        self.firestore.collection("users").whereField("uid", isEqualTo: user!.uid).getDocuments { (snapshot, _) in
            for document in snapshot!.documents {
                self.firestore.collection("users").document(document.documentID).updateData([
                    "username": username
                ])
            }
        }
    }
}

class FirebaseSession: ObservableObject {
    let auth = Auth.auth()
    private let firestore = Firestore.firestore()

    func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        self.auth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, (error.localizedDescription))
                return
            }
            completion(true, (result?.user.email)!)
        }
    }

    func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        self.auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, (error.localizedDescription))
                return
            }
            completion(true, (result?.user.email)!)
            self.firestore.collection("users").addDocument(data: [
                "uid": self.auth.currentUser!.uid,
                "username": "Username"
            ])
        }
    }
}
