import UIKit
import Firebase

final class LearningPresenter: LearningPresenterProtocol {
    weak var view: LearningViewProtocol?
    
    let storage = Storage.storage().reference()
    let userID = Auth.auth().currentUser?.uid
    let db  = Firestore.firestore()
    var allVerbs = [IrregularVerb]()
    var bestScore = Int()
    
    func onViewDidLoad() {
        bestScoreFromFirebase()
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
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func bestScoreFromFirebase(){
        guard let user = userID else { return }
        db.collection("users").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    DispatchQueue.main.async {
                        print("\(document.documentID) => \(document.data())")
                        self.bestScore = document.data()["bestScore"] as? Int ?? 0
                        self.view?.scoreUpdate()
                    }
                }
            }
        }
    }
    
    func randomElement() -> (verb: IrregularVerb?, tense: Int) {
        let random = Int.random(in: 1...3)
        let verb = allVerbs.randomElement()
        return (verb, random)
    }
    
    func scoreServerUpdate() {
        bestScore = view?.score ?? bestScore
        updateBestScore()
    }
    
    private func updateBestScore() {
        guard let user = userID else { return }
        db.collection("users").whereField("uid", isEqualTo: user).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    document.reference.updateData(["bestScore" : self.bestScore])
                }
            }
        }
    }
}
