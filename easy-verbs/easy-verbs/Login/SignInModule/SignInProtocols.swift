import Foundation

protocol SignInViewProtocol: class {
}

protocol SignInPresenterProtocol: class {
    func authState(email: String, password: String) -> Bool
}
