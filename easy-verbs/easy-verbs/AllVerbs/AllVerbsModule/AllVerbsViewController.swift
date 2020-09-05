import UIKit
import Firebase

final class AllVerbsViewController: UIViewController, AllVerbsViewProtocol {
    private let presenter: AllVerbsPresenterProtocol
    var isSearchInProgress: Bool = false

    init(presenter: AllVerbsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let backButton = UIButton()
    let searchBar = UISearchBar()
    let verbTableView = UITableView()
    
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
        presenter.onViewDidLoad()
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

    // MARK: -> Search
    private func doSearchText(_ text: String) {
        presenter.doSerchText(text)
    }

    // MARK: -> Button Did Tap
    @objc func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func reloadTableView() {
        self.verbTableView.reloadData()
    }
}

extension AllVerbsViewController: UITableViewDelegate {
}

extension AllVerbsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tableViewNumberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VerbCell()
        let verb = presenter.currentVerbs(indexPath: indexPath)
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
