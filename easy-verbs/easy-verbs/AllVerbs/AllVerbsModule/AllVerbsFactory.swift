import UIKit

final class AllVerbsFactory {
    static func make() -> UIViewController {
        let presenter = AllVerbsPresenter()
        let viewController = AllVerbsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
