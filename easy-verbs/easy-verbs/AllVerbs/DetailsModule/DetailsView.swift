import UIKit
import AVFoundation

class DetailsView: UIViewController, DetailsViewProtocol {
    private let presenter: DetailsPresenterProtocol
    var verbFromDelegate: IrregularVerb?
    
    init(presenter: DetailsPresenterProtocol, verb: IrregularVerb?) {
        self.presenter = presenter
        self.verbFromDelegate = verb
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView = UIStackView()
    let infinitiveLabel = UILabel()
    let pastSimpleLabel = UILabel()
    let pastPerfectLabel = UILabel()
    let descriptionLabel = UILabel()
    let pronunciationButton = UIButton()
    let favoritesButton = UIButton()
    let backButton = UIButton()
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontName: String = "Roboto-Regular"
        static let fontBoldName: String = "Roboto-Bold"
        static let fontSizeDescriptionAndButtons: CGFloat = 17.0
        static let fontSizeVerbs: CGFloat = 25.0
        static let leadingMargin: CGFloat = 60.0
        static let trailingMargin: CGFloat = -60.0
        static let textLeftButton: String = "PRONUN CIATION"
        static let textRightButton: String = "FAVORITES"
        static let buttonWidth: CGFloat = 120.0
        static let buttonHeight: CGFloat = 100.0
        static let buttonMargin: CGFloat = -100.0
        static let textColor: UIColor = .white
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewsConstraints()
        presenter.onViewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let contentHeight = stackView.frame.height + descriptionLabel.frame.height + favoritesButton.frame.height + 300
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentHeight)
        print(contentView.frame.height)
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        setUpBackButton()
        setUpDescriptionLabel()
        setUpStackView()
        setupLabels([infinitiveLabel, pastSimpleLabel, pastPerfectLabel])
        setupButtons([pronunciationButton, favoritesButton])
    }
    
    func setUpViewsConstraints() {
        setUpScrollViewConstraint()
        setUpScrollContentConstraint()
        setUpBackButtonConstraint()
        setUpDescriptionLabelConstraint()
        setUpStackViewConstraint()
        setUpInfinitiveLabelConstraint()
        setUpPastSimpleLabelLabelConstraint()
        setUpPastPerfectLabelLabelConstraint()
        setUpPronunciationButtonConstraint()
        setUpFavoritesButtonConstraint()
    }
    
    func setUpScrollViewConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func setUpScrollContentConstraint() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 800.0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
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
            contentView.addSubview($0)
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
        contentView.addSubview(backButton)
    }
    
    func setUpBackButtonConstraint() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45),
            backButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 70)
            ])
    }
    
    //MARK: -> Set Up Description Label
    func setUpDescriptionLabel() {
        descriptionLabel.textColor = Constants.textColor
        descriptionLabel.font = UIFont(name: Constants.fontName, size: Constants.fontSizeDescriptionAndButtons)
        descriptionLabel.contentMode = .left
        descriptionLabel.text = verbFromDelegate?.description
        descriptionLabel.wordWrap()
        contentView.addSubview(descriptionLabel)
    }
    
    func setUpDescriptionLabelConstraint() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMargin),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    //MARK: -> Set Up Stack View
    func setUpStackView() {
        stackView.axis = .vertical
        stackView.spacing = 42
        contentView.addSubview(stackView)
    }
    
    func setUpStackViewConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMargin),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            stackView.heightAnchor.constraint(equalToConstant: 200.0),
            stackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -50)
            ])
    }
    
    //MARK: -> Set Up Infinitive Label
    func setUpInfinitiveLabelConstraint() {
        infinitiveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infinitiveLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMargin),
            infinitiveLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin)
            ])
    }
    
    //MARK: -> Set Up Past Simple Label
    func setUpPastSimpleLabelLabelConstraint() {
        pastSimpleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pastSimpleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMargin),
            pastSimpleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin)
            ])
    }
    
    //MARK: -> Set Up Past Perfect Label
    func setUpPastPerfectLabelLabelConstraint() {
        pastPerfectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pastPerfectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMargin),
            pastPerfectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin)
            ])
    }
    
    //MARK: -> Set Up Pronunciation Button
    func setUpPronunciationButtonConstraint() {
        pronunciationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pronunciationButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            pronunciationButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            pronunciationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            pronunciationButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50)
            ])
    }
    
    //MARK: -> Set Up Favorites Button
    func setUpFavoritesButtonConstraint() {
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritesButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            favoritesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            favoritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingMargin),
            favoritesButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50)
            ])
    }
    
    //MARK: -> Buttons
    @objc func soundButton(_ sender: Any) {
        guard let url = presenter.soundURL() else { return }
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: url)
             audioPlayer.play()
        } catch {
           // Alert?
        }
    }
    
    @objc func addToFavoritesButton(_ sender: Any) {
        presenter.addToFavorites()
    }
    
    func colorButtonOnStart(favoriteOrNot: Bool) {
        if favoriteOrNot {
            favoritesButton.createBorderWhiteColor()
        } else {
            favoritesButton.createBorderProjectColor()
        }
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
