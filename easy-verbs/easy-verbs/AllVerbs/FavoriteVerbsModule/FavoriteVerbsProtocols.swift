import Foundation

protocol FavoriteVerbsViewProtocol: class {
    var isSearchInProgress: Bool { get }
    func reloadTableView()
}

protocol FavoriteVerbsPresenterProtocol: class {
    var tableViewNumberOfRowsInSection: Int { get }
    func onViewDidLoad()
    func doSearchText(_ text: String)
    func currentVerbs(indexPath: IndexPath) -> IrregularVerb
}
