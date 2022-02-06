
import SwiftUI
import Firebase
import FirebaseAuth

struct AuthorizationView: View {

    @State var message = ""
    @State var show = false
    @State private var email = ""
    @State private var pass = ""
    @State private var forgotPass = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .center) {
            colorScheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea()
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                Text("Authorization")
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                TextField("E-mail", text: $email)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.vertical, 15)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                    .padding(.horizontal, 50)
                SecureField("Password", text: $pass)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .padding(.vertical, 15)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                    .padding(.horizontal, 50)
                Button(action: {
                    signInWithEmail(email: email, password: pass) { (verified, status) in
                        if !verified {
                            self.message = status
                            self.show.toggle()
                        } else {
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"),
                                                            object: nil)
                        }
                    }
                }) {
                    Text("Sign in")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                }
                Spacer()
                Button(action: { forgotPass.toggle() }) {
                    Text("Forgot password?")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                } .sheet(isPresented: $forgotPass) { ForgotPassView() }
            }
            if show { withAnimation { AlertView(message: self.message, show: self.$show) } }
        }
    }
}

struct ForgotPassView: View {

    @State private var email = ""
    @State private var show = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .center) {
            colorScheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea()
            VStack(alignment: .center, spacing: 20) {
                TextField("E-mail", text: $email)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 15)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                    .padding(.horizontal, 50)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                Button(action: {
                    Auth.auth().sendPasswordReset(withEmail: email)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Submit")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                }
            }
        }
    }
}

func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        if err != nil {
            completion(false, (err?.localizedDescription) as! String)
            return
        }
        completion(true, (res?.user.email)!)
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
