import UIKit

final class SignInFactory {
    static func make() -> UIViewController {
        let presenter = SignInPresenter()
        let viewController = SignInView(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
