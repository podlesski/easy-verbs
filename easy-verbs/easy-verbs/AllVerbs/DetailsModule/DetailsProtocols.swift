import Foundation

protocol DetailsViewProtocol: class {
    var verbFromDelegate: IrregularVerb? { get }
    func colorButtonOnStart(favoriteOrNot: Bool)
}

protocol DetailsPresenterProtocol: class {
    func onViewDidLoad()
    func addToFavorites()
    func soundURL() -> URL?
}
