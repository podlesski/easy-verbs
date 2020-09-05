import UIKit

final class DetailsFactory {
    static func make(verb: IrregularVerb?) -> UIViewController {
        let presenter = DetailsPresenter()
        let viewController = DetailsView(presenter: presenter, verb: verb)
        presenter.view = viewController
        return viewController
    }
}
