//
//  AllVerbsViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/23/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import Firebase

class AllVerbsViewController: UIViewController {
    
    let backButton = UIButton()
    let searchBar = UISearchBar()
    let verbTableView = UITableView()
    
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
    var resaltsOfSearch = [IrregularVerb]()
    var allVerbs = [IrregularVerb]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "projectColor2")
        
        setUpBackButton()
        setUpBackButtonConstraint()
        
        setUpSearchBar()
        setUpSearchBarConstraint()
        
        setUpVerbTableView()
        setUpVerbTableViewConstraint()
        
        resaltsOfSearch = allVerbs
        
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
                    self.verbTableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    //MARK: -> Set Up Back Button
    func setUpBackButton() {
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(named: "projectColor")
        backButton.backgroundColor = UIColor(named: "projectColor2")
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func setUpBackButtonConstraint() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
    }
    
    //MARK: -> Set Up Search Bar
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.textColor = UIColor(named: "projectColor")
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = UIColor(named: "projectColor2")
        searchBar.backgroundColor = UIColor(named: "projectColor2")
        searchBar.tintColor = UIColor(named: "projectColor")
        self.view.addSubview(searchBar)
    }
    
    func setUpSearchBarConstraint() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
    }
    
    //MARK: -> Set Up Verb Table View
    func setUpVerbTableView() {
        verbTableView.delegate = self
        verbTableView.dataSource = self
        verbTableView.rowHeight = 100
        verbTableView.separatorStyle = .none
        verbTableView.backgroundColor = UIColor(named: "projectColor2")
        self.view.addSubview(verbTableView)
    }
    
    func setUpVerbTableViewConstraint() {
        verbTableView.translatesAutoresizingMaskIntoConstraints = false
        verbTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        verbTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        verbTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        verbTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailsViewController,
            let verb = sender as? IrregularVerb {
            destinationVC.verbFromDelegate = verb
        }
    }
    
    // MARK: -> Search
    private func doSearchText(_ text: String) {
        searchOperationQueue.cancelAllOperations()
        
        searchOperationQueue.addOperation { [weak self] in
            guard let self = self else { return }
            self.resaltsOfSearch = self.allVerbs.filter { $0.infinitive!.starts(with: text)  }
            
            DispatchQueue.main.async { [weak self] in
                self?.verbTableView.reloadData()
            }
        }
    }
    
    // MARK: -> Button Did Tap
    @objc func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AllVerbsViewController: UITableViewDelegate {
}

extension AllVerbsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return isSearchInProgress ? resaltsOfSearch.count : allVerbs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VerbCell()
        let verb = isSearchInProgress ? resaltsOfSearch[indexPath.row] : allVerbs[indexPath.row]
        cell.delegate = self
        cell.update(with: verb)
        return cell
    }
}

//MARK: -> Extensions
extension AllVerbsViewController: UISearchBarDelegate {
    
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

extension AllVerbsViewController: VerbCellDelegate {
    func didTapOnVerbButton(with verb: IrregularVerb?) {
        let newVC = DetailsViewController()
        newVC.modalPresentationStyle = .fullScreen
        newVC.verbFromDelegate = verb
        self.present(newVC, animated: true, completion: nil)        
    }
}
