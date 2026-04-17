import Foundation
import FirebaseAuth
import GoogleSignIn

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

public final class AuthService {
    public static let shared = AuthService()
    private init() {}
    
    // Using @MainActor because GIDSignIn requires the presenting ViewController
    @MainActor
    func signInWithGoogle(presenting: UIViewController) async throws -> AuthDataResultModel {
        
        // 1. Trigger the Google Sign In flow
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
        
        // 2. Extract the tokens needed for Firebase
        guard let idToken = signInResult.user.idToken?.tokenString else {
            throw NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Google ID Token missing"])
        }
        
        let accessToken = signInResult.user.accessToken.tokenString
        
        // 3. Create a Firebase Credential
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        // 4. Sign in to Firebase with that credential
        let authResult = try await Auth.auth().signIn(with: credential)
        
        // 5. Map the Firebase User to your custom Model
        return AuthDataResultModel(user: authResult.user)
    }
}
