import UIKit
import Firebase

final class SignInPresenter: SignInPresenterProtocol {
    weak var view: SignInViewProtocol?
    
    func authState(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard self != nil else {
                return
            }
            guard error == nil else {
                self?.view?.showAlertFromPresenter()
                return
            }
            self?.view?.openNewVC()
        }
    }
}
