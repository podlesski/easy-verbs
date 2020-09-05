import UIKit

final class LearningFactory {
    static func make() -> UIViewController {
        let presenter = LearningPresenter()
        let viewController = LearningView(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
