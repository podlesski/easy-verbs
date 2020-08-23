//
//  FavoritesVerbsViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 3/3/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import Firebase


class FavoritesVerbsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var isSearchInProgress = false
    private lazy var searchOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    let storage = Storage.storage().reference()
    let db  = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    var resaltsOfSearch = [IrregularVerb]()
    var allVerbs = [IrregularVerb]()
    var userFavorite = [IrregularVerb]()
    var favoritesVerbs = [String]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var verbTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verbTableView.delegate = self
        verbTableView.dataSource = self
        verbTableView.rowHeight = 100
        verbTableView.separatorStyle = .none
        searchBar.searchTextField.textColor = UIColor(named: "projectColor")
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailsViewController,
            let verb = sender as? IrregularVerb {
            destinationVC.verbFromDelegate = verb
        }
    }
    
    private func doSearchText(_ text: String) {
        searchOperationQueue.cancelAllOperations()
        
        searchOperationQueue.addOperation { [weak self] in
            guard let self = self else { return }
            self.resaltsOfSearch = self.userFavorite.filter { $0.infinitive!.starts(with: text)  }
            
            DispatchQueue.main.async { [weak self] in
                self?.verbTableView.reloadData()
            }
        }
    }
    
    func filterByFavorite() -> [IrregularVerb] {
        let favorite = allVerbs.filter {
            favoritesVerbs.contains($0.infinitive ?? "") }
        print(favorite.count)
        return favorite
    }
    
    func favoritesVerbsFromFirebase() {
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
                            self.verbTableView.reloadData()
                        }
                    }
                }
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FavoritesVerbsViewController: UITableViewDelegate {
}

extension FavoritesVerbsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return isSearchInProgress ? resaltsOfSearch.count : userFavorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "FavoritesVerbIDCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? FavoritesVerbCell else { fatalError("Can't not find cell with \(cellID) at index \(indexPath)")
        }
        
        let verb = isSearchInProgress ? resaltsOfSearch[indexPath.row] : userFavorite[indexPath.row]
        cell.delegate = self
        cell.update(with: verb)
        return cell
    }
}


extension FavoritesVerbsViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearchInProgress = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = nil
        isSearchInProgress = false
        verbTableView.reloadData()
    }
}

extension FavoritesVerbsViewController: FavoritesVerbCellDelegate {
    
    func didTapOnVerbButton(with verb: IrregularVerb?) {
        
        performSegue(withIdentifier: "FavoritesDetailsSegue", sender: verb)
        
    }
}



