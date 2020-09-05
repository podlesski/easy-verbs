import UIKit
import Firebase

final class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewProtocol?
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let authResult = authResult else { return }
            guard error == nil else {
                self.view?.showAlert(title: "Error", message: "\(String(describing: error?.localizedDescription))")
                return
            }
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: [
                "email": email,
                "password": password,
                "uid": authResult.user.uid,
                "bestScore": 0,
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                }
            }
        }
    }
}
