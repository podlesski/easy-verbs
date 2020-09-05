import UIKit
import AVFoundation
import Firebase


class DetailsViewController: UIViewController {
    
    //MARK: -> Firebase References
    var verbFromDelegate: IrregularVerb?
    let db  = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    let stackView = UIStackView()
    let infinitiveLabel = UILabel()
    let pastSimpleLabel = UILabel()
    let pastPerfectLabel = UILabel()
    let descriptionLabel = UILabel()
    let pronunciationButton = UIButton()
    let favoritesButton = UIButton()
    let backButton = UIButton()
    var favoritesVerbs = [String]()
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontName: String = "Roboto-Regular"
        static let fontBoldName: String = "Roboto-Bold"
        static let fontSizeDescriptionAndButtons: CGFloat = 17.0
        static let fontSizeVerbs: CGFloat = 25.0
        static let leadingMargin: CGFloat = 40.0
        static let trailingMargin: CGFloat = -40.0
        static let textLeftButton: String = "PRONUN CIATION"
        static let textRightButton: String = "FAVORITES"
        static let buttonWidth: CGFloat = 120.0
        static let buttonHeight: CGFloat = 100.0
        static let buttonMargin: CGFloat = -100.0
        static let textColor: UIColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewsConstraints()
        downloadFavoriteVerbs()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(named: Constants.secondProjectColor)
        setUpBackButton()
        setUpDescriptionLabel()
        setUpStackView()
        setupLabels([infinitiveLabel, pastSimpleLabel, pastPerfectLabel])
        setupButtons([pronunciationButton, favoritesButton])
    }
    
    func setUpViewsConstraints() {
        setUpBackButtonConstraint()
        setUpDescriptionLabelConstraint()
        setUpStackViewConstraint()
        setUpInfinitiveLabelConstraint()
        setUpPastSimpleLabelLabelConstraint()
        setUpPastPerfectLabelLabelConstraint()
        setUpPronunciationButtonConstraint()
        setUpFavoritesButtonConstraint()
    }
    
    func setupLabels(_ labels: [UILabel]) {
        labels.forEach {
            $0.textColor = UIColor(named: Constants.projectColor)
            $0.font = UIFont(name: Constants.fontBoldName, size: Constants.fontSizeVerbs)
            $0.contentMode = .left
            $0.wordWrap()
            stackView.addArrangedSubview($0)
        }
        updateLabels()
    }
    
    func updateLabels() {
        infinitiveLabel.text = verbFromDelegate?.infinitive
        pastSimpleLabel.text = verbFromDelegate?.pastSimple
        pastPerfectLabel.text = verbFromDelegate?.pastParticiple
    }
    
    func setupButtons(_ buttons: [UIButton]) {
        buttons.forEach {
            $0.titleLabel?.font = UIFont(name: Constants.fontBoldName, size: Constants.fontSizeDescriptionAndButtons)
            $0.setTitleColor(Constants.textColor, for: .normal)
            $0.titleLabel?.wordWrap()
            $0.createBorderWhiteColor()
            self.view.addSubview($0)
        }
        updateButtons()
    }
    
    func updateButtons() {
        pronunciationButton.setTitle(Constants.textLeftButton, for: .normal)
        favoritesButton.setTitle(Constants.textRightButton, for: .normal)
        pronunciationButton.addTarget(self, action: #selector(soundButton), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(addToFavoritesButton), for: .touchUpInside)
        pronunciationButton.highlightOfBorder()
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
    
    //MARK: -> Set Up Description Label
    func setUpDescriptionLabel() {
        descriptionLabel.textColor = Constants.textColor
        descriptionLabel.font = UIFont(name: Constants.fontName, size: Constants.fontSizeDescriptionAndButtons)
        descriptionLabel.contentMode = .left
        descriptionLabel.text = verbFromDelegate?.description
        descriptionLabel.wordWrap()
        self.view.addSubview(descriptionLabel)
    }
    
    func setUpDescriptionLabelConstraint() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.trailingMargin),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
            descriptionLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    //MARK: -> Set Up Stack View
    func setUpStackView() {
        stackView.axis = .vertical
        stackView.spacing = 42
        self.view.addSubview(stackView)
    }
    
    func setUpStackViewConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.trailingMargin),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            stackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -50)
            ])
    }
    
    //MARK: -> Set Up Infinitive Label
    func setUpInfinitiveLabelConstraint() {
        infinitiveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infinitiveLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.trailingMargin),
            infinitiveLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin)
            ])
    }
    
    //MARK: -> Set Up Past Simple Label
    func setUpPastSimpleLabelLabelConstraint() {
        pastSimpleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pastSimpleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.trailingMargin),
            pastSimpleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin)
            ])
    }
    
    //MARK: -> Set Up Past Perfect Label
    func setUpPastPerfectLabelLabelConstraint() {
        pastPerfectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pastPerfectLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.trailingMargin),
            pastPerfectLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin)
            ])
    }
    
    //MARK: -> Set Up Pronunciation Button
    func setUpPronunciationButtonConstraint() {
        pronunciationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pronunciationButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            pronunciationButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            pronunciationButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            pronunciationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
            ])
    }
    
    //MARK: -> Set Up Favorites Button
    func setUpFavoritesButtonConstraint() {
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritesButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            favoritesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            favoritesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: Constants.trailingMargin),
            favoritesButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
            ])
    }

    //MARK: -> Download Favorite Verbs
    func downloadFavoriteVerbs() {
        guard let user = userID else { return }
        db.collection("users").whereField("uid", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        DispatchQueue.global().async {
                            print("\(document.documentID) => \(document.data())")
                            self.favoritesVerbs =  document.data()["favoritesVerbs"] as? [String] ?? []
                            print(self.favoritesVerbs)
                            DispatchQueue.main.async {
                                self.colorButtonOnStart(favoriteOrNot: self.favoriteOrNot())
                            }
                        }
                    }
                }
        }
    }
    
    func repeatDownloadFavoriteVerbs() {
        guard let user = userID else { return }
        //weak self
        db.collection("users").whereField("uid", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        DispatchQueue.global().async {
                            print("\(document.documentID) => \(document.data())")
                            self.favoritesVerbs =  document.data()["favoritesVerbs"] as? [String] ?? []
                            print(self.favoritesVerbs)
                            DispatchQueue.main.async {
                                self.colorButtonOnStart(favoriteOrNot: self.repeatFavoriteOrNot())
                            }
                        }
                    }
                }
        }
    }
    
    func deleteFavoriteVerbs() {
        guard let user = userID else { return }
        guard let verb = verbFromDelegate?.infinitive else { return }
        db.collection("users").whereField("uid", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
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
    
    func addFavoriteVerbs() {
        guard let user = userID else { return }
        guard let verb = verbFromDelegate?.infinitive else { return }
        db.collection("users").whereField("uid", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
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
    
    //MARK: -> Buttons
    @objc func soundButton(_ sender: Any) {
        guard let url = soundURL() else { return }
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: url)
             audioPlayer.play()
        } catch {
           // Alert?
        }
    }
    
    @objc func addToFavoritesButton(_ sender: Any) {
        if favoriteOrNot() {
            addFavoriteVerbs()
            repeatDownloadFavoriteVerbs()
        } else {
            deleteFavoriteVerbs()
            repeatDownloadFavoriteVerbs()
        }
    }
    
    func favoriteOrNot() -> Bool {
        if favoritesVerbs.contains(verbFromDelegate?.infinitive ?? "ERROR") {
            return false
        } else {
            return true
        }
    }
    
    func repeatFavoriteOrNot() -> Bool {
        if favoritesVerbs.contains(verbFromDelegate?.infinitive ?? "ERROR") {
            return true
        } else {
            return false
        }
    }
    
    func colorButtonOnStart(favoriteOrNot: Bool) {
        if favoriteOrNot {
            favoritesButton.createBorderWhiteColor()
        } else {
            favoritesButton.createBorderProjectColor()
        }
    }
    
    func soundURL() -> URL? {
        guard let verb = verbFromDelegate,
            let path = Bundle.main.path(forResource: verb.infinitive, ofType: "mp3")
        else {
            return nil
        }
        let sound = URL(fileURLWithPath: path)
        return sound
    }
    
    @objc func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: -> Extensions
extension UIButton {
    @objc func startHighlight(sender: UIButton) {
        self.layer.borderColor = UIColor(named:"projectColor")?.cgColor
    }
    
    @objc func stopHighlight(sender: UIButton) {
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    func highlightOfBorder() {
        self.addTarget(self, action: #selector(startHighlight), for: .touchDown)
        self.addTarget(self, action: #selector(stopHighlight), for: .touchUpInside)
        self.addTarget(self, action: #selector(stopHighlight), for: .touchUpOutside)
    }
    
    func createBorderProjectColor() {
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(named:"projectColor")?.cgColor
        self.setTitleColor(UIColor(named: "projectColor"), for: .normal)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0
    }
    
    func createBorderWhiteColor() {
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.white.cgColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor(named: "projectColor"), for: .highlighted)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0
    }
}

extension UILabel {
    func wordWrap() {
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
    }
}
