import UIKit

final class SignUpFactory {
    static func make() -> UIViewController {
        let presenter = SignUpPresenter()
        let viewController = SignUpView(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
