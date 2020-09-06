import UIKit

class MenuView: UIViewController, MenuViewProtocol {
    private let presenter: MenuPresenterProtocol
    
    init(presenter: MenuPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let background = UIView()
    let buttonTableView = UITableView()
    let appNameLabel = UILabel()
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontBoldName: String = "Roboto-Bold"
        static let fontSizeLabel: CGFloat = 48.0
        static let sizeLabel: CGFloat = 180.0
        static let rowHight: CGFloat = 200.0
        static let textLabel: String = "EASY VERBS"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewsConstraints()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(named: Constants.secondProjectColor)
        setUpBackground()
        setUpAppNameLabel()
        setUpButtonTableView()
    }
    
    func setUpViewsConstraints() {
        setUpBackgroundConstraint()
        setUpAppNameLabelConstraint()
        setUpButtonTableViewConstraint()
    }
    
    //MARK: -> Set Up Background
    func setUpBackground() {
        background.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.view.addSubview(background)
    }
    
    func setUpBackgroundConstraint() {
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            background.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            background.topAnchor.constraint(equalTo: self.view.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 220)
            ])
    }
    
    //MARK: -> Set Up App Name Label
    func setUpAppNameLabel() {
        appNameLabel.text = Constants.textLabel
        appNameLabel.textColor = UIColor(named: Constants.projectColor)
        appNameLabel.font = UIFont(name: Constants.fontBoldName, size: Constants.fontSizeLabel)
        appNameLabel.lineBreakMode = .byWordWrapping
        appNameLabel.numberOfLines = 2
        appNameLabel.textAlignment = .center
        appNameLabel.backgroundColor = .clear
        appNameLabel.layer.borderWidth = 4
        appNameLabel.layer.borderColor = UIColor(named:Constants.projectColor)?.cgColor
        self.view.addSubview(appNameLabel)
    }
    
    func setUpAppNameLabelConstraint() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appNameLabel.heightAnchor.constraint(equalToConstant: Constants.sizeLabel),
            appNameLabel.widthAnchor.constraint(equalToConstant: Constants.sizeLabel),
            appNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            appNameLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor, constant: 20)
            ])
    }
    
    //MARK: -> Set Up Button Table View
    func setUpButtonTableView() {
        buttonTableView.rowHeight = Constants.rowHight
        buttonTableView.dataSource = self
        buttonTableView.delegate = self
        buttonTableView.separatorStyle = .none
        buttonTableView.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.view.addSubview(buttonTableView)
    }
    
    func setUpButtonTableViewConstraint() {
        buttonTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            buttonTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            buttonTableView.topAnchor.constraint(equalTo: background.bottomAnchor),
            buttonTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
}

//MARK: -> Extensions
extension UIButton {
    func addColorBorder() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(named: "projectColor")?.cgColor
    }
}

extension MenuView: UITableViewDelegate {
}

extension MenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.buttonsOnMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ButtonTableViewCell()
        cell.delegate = self
        cell.update(with: presenter.buttonsOnMenu[indexPath.row])
        return cell
    }
    
}

extension MenuView: ButtonTableViewCellDelegate {
    func didTapOnMenuButton(with name: String) {
        self.present(presenter.createNewVC(with: name), animated: true, completion: nil)
    }
}
