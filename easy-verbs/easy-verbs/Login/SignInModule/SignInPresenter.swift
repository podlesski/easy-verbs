import UIKit
import Firebase

final class SignInPresenter: SignInPresenterProtocol {
    weak var view: SignInViewProtocol?
    
    func authState(email: String, password: String) -> Bool {
        var authState: Bool = false
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard self != nil else {
                return
            }
            guard error == nil else {
                return
            }
            authState = true
        }
        return authState
    }
}
