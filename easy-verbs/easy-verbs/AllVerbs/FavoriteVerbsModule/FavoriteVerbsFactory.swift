import UIKit

final class FavoriteVerbsFactory {
    static func make() -> UIViewController {
        let presenter = FavoriteVerbsPresenter()
        let viewController = FavoriteVerbsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
