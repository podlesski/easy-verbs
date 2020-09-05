import UIKit
import Firebase

final class AllVerbsPresenter: AllVerbsPresenterProtocol {
    weak var view: AllVerbsViewProtocol?

    private lazy var searchOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    let storage = Storage.storage().reference()
    var resaltsOfSearch = [IrregularVerb]()
    var allVerbs = [IrregularVerb]()

    var tableViewNumberOfRowsInSection: Int {
        view?.isSearchInProgress ?? false ? resaltsOfSearch.count : allVerbs.count
    }

    func currentVerbs(indexPath: IndexPath) -> IrregularVerb {
        view?.isSearchInProgress ?? false ? resaltsOfSearch[indexPath.row] : allVerbs[indexPath.row]
    }

    func onViewDidLoad() {
        resaltsOfSearch = allVerbs

        let allVerbsRef = storage.child("easy_verbs.json")
        allVerbsRef.getData(maxSize: Int64.max) { [weak self] (data, error) in
            guard error == nil else { return }
            guard let self = self else { return }
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([IrregularVerb].self, from: data)
                print(json)
                DispatchQueue.main.async {
                    self.allVerbs = json
                    self.view?.reloadTableView()
                }
            } catch let error {
                print(error)
            }
        }
    }

    func doSerchText(_ text: String) {
        searchOperationQueue.cancelAllOperations()

        searchOperationQueue.addOperation { [weak self] in
            guard let self = self else { return }
            self.resaltsOfSearch = self.allVerbs.filter { $0.infinitive!.starts(with: text)  }

            DispatchQueue.main.async { [weak self] in
                self?.view?.reloadTableView()
            }
        }
    }
}
