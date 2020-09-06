import Foundation

protocol SignInViewProtocol: class {
    func openNewVC()
    func showAlertFromPresenter()
}

protocol SignInPresenterProtocol: class {
    func authState(email: String, password: String)
}
