import UIKit

final class MenuFactory {
    static func make() -> UIViewController {
        let presenter = MenuPresenter()
        let viewController = MenuView(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
