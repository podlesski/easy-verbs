import UIKit
import Firebase

final class FavoriteVerbsPresenter: FavoriteVerbsPresenterProtocol {
    weak var view: FavoriteVerbsViewProtocol?
    
    let storage = Storage.storage().reference()
    let userID = Auth.auth().currentUser?.uid
    let db  = Firestore.firestore()
    var resaltsOfSearch = [IrregularVerb]()
    var allVerbs = [IrregularVerb]()
    var userFavorite = [IrregularVerb]()
    var favoritesVerbs = [String]()
    
    private lazy var searchOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    var tableViewNumberOfRowsInSection: Int {
        view?.isSearchInProgress ?? false ? resaltsOfSearch.count : userFavorite.count
    }

    func currentVerbs(indexPath: IndexPath) -> IrregularVerb {
        view?.isSearchInProgress ?? false ? resaltsOfSearch[indexPath.row] : userFavorite[indexPath.row]
    }
    
    func onViewDidLoad() {
        resaltsOfSearch = userFavorite
        // MARK: -> Loading JSON
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
                    self.favoritesVerbsFromFirebase()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func favoritesVerbsFromFirebase() {
        guard let user = userID else { return }
        db.collection("users").whereField("uid", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        DispatchQueue.main.async {
                            print("\(document.documentID) => \(document.data())")
                            self.favoritesVerbs =  document.data()["favoritesVerbs"] as? [String] ?? []
                            print(self.favoritesVerbs)
                            self.userFavorite = self.filterByFavorite()
                            self.view?.reloadTableView()
                        }
                    }
                }
        }
    }
    
    private func filterByFavorite() -> [IrregularVerb] {
        let favorite = allVerbs.filter {
            favoritesVerbs.contains($0.infinitive ?? "") }
        print(favorite.count)
        return favorite
    }
    
    func doSearchText(_ text: String) {
        searchOperationQueue.cancelAllOperations()
        searchOperationQueue.addOperation { [weak self] in
            guard let self = self else { return }
            self.resaltsOfSearch = self.userFavorite.filter { $0.infinitive!.starts(with: text)  }
            DispatchQueue.main.async { [weak self] in
                self?.view?.reloadTableView()
            }
        }
    }
}
