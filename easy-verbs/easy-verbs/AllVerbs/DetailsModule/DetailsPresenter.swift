import UIKit
import Firebase

final class DetailsPresenter: DetailsPresenterProtocol {
    weak var view: DetailsViewProtocol?
    
    let db  = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    var favoritesVerbs = [String]()
    
    func onViewDidLoad() {
        guard let user = userID else { return }
        db.collection("users").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    DispatchQueue.global().async {
                        print("\(document.documentID) => \(document.data())")
                        self.favoritesVerbs =  document.data()["favoritesVerbs"] as? [String] ?? []
                        print(self.favoritesVerbs)
                        DispatchQueue.main.async {
                            self.view?.colorButtonOnStart(favoriteOrNot: self.favoriteOrNot())
                        }
                    }
                }
            }
        }
    }
    
    //MARK: -> Favorite Button
    private func favoriteOrNot() -> Bool {
        if favoritesVerbs.contains(view?.verbFromDelegate?.infinitive ?? "please reload app") {
            return false
        } else {
            return true
        }
    }
    
    private func repeatFavoriteOrNot() -> Bool {
        if favoritesVerbs.contains(view?.verbFromDelegate?.infinitive ?? "please reload app") {
            return true
        } else {
            return false
        }
    }
    
    func addToFavorites() {
        if favoriteOrNot() {
            addFavoriteVerbs()
            repeatDownloadFavoriteVerbs()
        } else {
            deleteFavoriteVerbs()
            repeatDownloadFavoriteVerbs()
        }
    }
    
    func addFavoriteVerbs() {
        guard let user = userID else { return }
        guard let verb = view?.verbFromDelegate?.infinitive else { return }
        db.collection("users").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    document.reference.updateData(["favoritesVerbs": FieldValue.arrayUnion([verb])])
                }
            }
        }
    }
    
    func deleteFavoriteVerbs() {
        guard let user = userID else { return }
        guard let verb = view?.verbFromDelegate?.infinitive else { return }
        db.collection("users").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    document.reference.updateData(["favoritesVerbs": FieldValue.arrayRemove([verb])])
                }
            }
        }
    }
    
    func repeatDownloadFavoriteVerbs() {
        guard let user = userID else { return }
        //weak self
        db.collection("users").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    DispatchQueue.global().async {
                        print("\(document.documentID) => \(document.data())")
                        self.favoritesVerbs =  document.data()["favoritesVerbs"] as? [String] ?? []
                        print(self.favoritesVerbs)
                        DispatchQueue.main.async {
                            self.view?.colorButtonOnStart(favoriteOrNot: self.repeatFavoriteOrNot())
                        }
                    }
                }
            }
        }
    }
    
    //MARK: -> Audio Button
    func soundURL() -> URL? {
        guard let verb = view?.verbFromDelegate,
            let path = Bundle.main.path(forResource: verb.infinitive, ofType: "mp3")
        else {
            return nil
        }
        let sound = URL(fileURLWithPath: path)
        return sound
    }
}
