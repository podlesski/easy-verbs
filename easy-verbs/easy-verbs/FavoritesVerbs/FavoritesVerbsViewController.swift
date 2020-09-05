import UIKit
import Firebase


class FavoritesVerbsViewController: UIViewController {
    
    let backButton = UIButton()
    let searchBar = UISearchBar()
    let verbTableView = UITableView()
    let storage = Storage.storage().reference()
    let db  = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    var resaltsOfSearch = [IrregularVerb]()
    var allVerbs = [IrregularVerb]()
    var userFavorite = [IrregularVerb]()
    var favoritesVerbs = [String]()
    private var isSearchInProgress = false
    private lazy var searchOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let rowHight: CGFloat = 100.0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewsConstraints()
        
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
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(named: Constants.secondProjectColor)
        setUpBackButton()
        setUpSearchBar()
        setUpVerbTableView()
    }
    
    func setUpViewsConstraints() {
        setUpBackButtonConstraint()
        setUpSearchBarConstraint()
        setUpVerbTableViewConstraint()
    }
    
    //MARK: -> Set Up Back Button
    func setUpBackButton() {
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(named: Constants.projectColor)
        backButton.backgroundColor = UIColor(named: Constants.secondProjectColor)
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func setUpBackButtonConstraint() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45),
            backButton.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 70)
            ])
    }
    
    //MARK: -> Set Up Search Bar
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor(named: Constants.projectColor)
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = UIColor(named: Constants.secondProjectColor)
        searchBar.backgroundColor = UIColor(named: Constants.secondProjectColor)
        searchBar.tintColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(searchBar)
    }
    
    func setUpSearchBarConstraint() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 70),
            searchBar.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25)
            ])
    }
    
    //MARK: -> Set Up Verb Table View
    func setUpVerbTableView() {
        verbTableView.delegate = self
        verbTableView.dataSource = self
        verbTableView.rowHeight = Constants.rowHight
        verbTableView.separatorStyle = .none
        verbTableView.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.view.addSubview(verbTableView)
    }
    
    func setUpVerbTableViewConstraint() {
        verbTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verbTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            verbTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            verbTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            verbTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
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
    
    @objc func backButtonDidTap(_ sender: Any) {
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
        let cell = VerbCell()
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

extension FavoritesVerbsViewController: VerbCellDelegate {
    func didTapOnVerbButton(with verb: IrregularVerb?) {
        let newVC = DetailsViewController()
        newVC.modalPresentationStyle = .fullScreen
        newVC.verbFromDelegate = verb
        self.present(newVC, animated: true, completion: nil)
    }
}



