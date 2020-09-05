import Foundation

protocol AllVerbsViewProtocol: class {
    var isSearchInProgress: Bool { get }

    func reloadTableView()
}

protocol AllVerbsPresenterProtocol: class {
    var tableViewNumberOfRowsInSection: Int { get }

    func onViewDidLoad()
    func doSerchText(_ text: String)
    func currentVerbs(indexPath: IndexPath) -> IrregularVerb
}
