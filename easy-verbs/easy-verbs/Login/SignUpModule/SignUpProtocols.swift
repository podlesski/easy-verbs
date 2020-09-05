import Foundation

protocol SignUpViewProtocol: class {
    func showAlert(title: String, message: String)
}

protocol SignUpPresenterProtocol: class {
    func createUser(email: String, password: String)
}
