import UIKit

class LearningView: UIViewController, LearningViewProtocol {
    private let presenter: LearningPresenterProtocol
    
    init(presenter: LearningPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var time = 60
    var timer = Timer()
    var currentEmptyVerb: String?
    var score = 0
    
    //MARK: -> Game UI Elements
    let labelOverTime = UILabel()
    let timerLabel = UILabel()
    let labelOverScore = UILabel()
    let scoreLabel = UILabel()
    let infinitiveLabel = UILabel()
    let pastSimpleLabel = UILabel()
    let pastPerfectLabel = UILabel()
    let fieldForWriteVerb = UITextField()
    let nextVerb = UIButton()
    let skipVerb = UIButton()
    
    //MARK: -> Start UI Elements
    let backButton = UIButton()
    let labelOverBestScore = UILabel()
    let bestScoreLabel = UILabel()
    let startGame = UIButton()
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontName: String = "Roboto-Bold"
        static let fontSizeMedium: CGFloat = 17.0
        static let fontSizeLarge: CGFloat = 25.0
        static let textStartButton: String = "START"
        static let textNextButton: String = "NEXT"
        static let textBestScoreLabel: String = "BEST SCORE"
        static let textScore: String = "0"
        static let textScoreLabel: String = "SCORE"
        static let textTimeLabel: String = "TIME"
        static let buttonWidth: CGFloat = 100.0
        static let buttonHeight: CGFloat = 65.0
        static let fieldLeadingMargin: CGFloat = 100.0
        static let fieldTrailingMargin: CGFloat = -100.0
        static let distanceBetweenElements: CGFloat = 50.0
        static let textColor: UIColor = .white
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let contentHeight = nextVerb.frame.height + fieldForWriteVerb.frame.height + infinitiveLabel.frame.height + pastSimpleLabel.frame.height + pastPerfectLabel.frame.height + scoreLabel.frame.height + labelOverScore.frame.height + 400
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentHeight)
        print(contentView.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewsConstraints()
        presenter.onViewDidLoad()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        setUpBackButton()
        setupButtons([startGame, nextVerb])
        setupLabels([bestScoreLabel, timerLabel, scoreLabel])
        setupVerbsLabels([pastSimpleLabel, infinitiveLabel, pastPerfectLabel])
        setupOverLabels([labelOverBestScore, labelOverTime, labelOverScore])
        setUpFieldForWriteVerb()
    }
    
    func setUpViewsConstraints() {
        setUpScrollViewConstraint()
        setUpScrollContentConstraint()
        setUpBackButtonConstraint()
        setUpStartGameButtonConstraint()
        setUpBestScoreLabelConstraint()
        setUpLabelOverBestScoreConstraint()
        setUpPastSimpleLabelConstraint()
        setUpInfinitiveLabelConstraint()
        setUpPastPerfectLabelConstraint()
        setUpFieldForWriteVerbConstraint()
        setUpNextButtonConstraint()
        setUpTimerLabelConstraint()
        setUpScoreLabelConstraint()
        setUpLabelOverTimerConstraint()
        setUpLabelOverScoreConstraint()
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
    
    func setupVerbsLabels(_ labels: [UILabel]) {
        labels.forEach {
            $0.font = UIFont(name: Constants.fontName, size: Constants.fontSizeLarge)
            $0.textColor = UIColor(named: Constants.projectColor)
            $0.isHidden = true
            contentView.addSubview($0)
        }
    }
    
    func setupLabels(_ labels: [UILabel]) {
        labels.forEach {
            $0.font = UIFont(name: Constants.fontName, size: Constants.fontSizeLarge)
            $0.textColor = Constants.textColor
            $0.textAlignment = .center
            $0.createWhiteBorder()
            contentView.addSubview($0)
        }
        scoreLabel.text = Constants.textScore
        scoreLabel.isHidden = true
        timerLabel.isHidden = true
    }
    
    func setupOverLabels(_ labels: [UILabel]) {
        labels.forEach {
            $0.font = UIFont(name: Constants.fontName, size: Constants.fontSizeMedium)
            $0.textColor = Constants.textColor
            $0.textAlignment = .center
            contentView.addSubview($0)
        }
        labelOverBestScore.text = Constants.textBestScoreLabel
        labelOverTime.text = Constants.textTimeLabel
        labelOverScore.text = Constants.textScoreLabel
        labelOverTime.isHidden = true
        labelOverScore.isHidden = true
    }
    
    func setupButtons(_ buttons: [UIButton]) {
        buttons.forEach {
            $0.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.fontSizeMedium)
            $0.setTitleColor(UIColor(named: Constants.secondProjectColor), for: .normal)
            $0.backgroundColor = UIColor(named: Constants.projectColor)
            contentView.addSubview($0)
        }
        startGame.setTitle(Constants.textStartButton, for: .normal)
        nextVerb.setTitle(Constants.textNextButton, for: .normal)
        startGame.addTarget(self, action: #selector(startLearning), for: .touchUpInside)
        nextVerb.addTarget(self, action: #selector(goToNextVerb), for: .touchUpInside)
        nextVerb.isHidden = true
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
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45),
            backButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 70)
            ])
    }
    
    //MARK: -> Set Up Start Game Button
    func setUpStartGameButtonConstraint() {
        startGame.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startGame.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            startGame.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            startGame.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            startGame.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
    
    //MARK: -> Set Up Best Score Label
    func setUpBestScoreLabelConstraint() {
        bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bestScoreLabel.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            bestScoreLabel.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            bestScoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bestScoreLabel.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -100)
            ])
    }
    
    //MARK: -> Set Up Label Over Best Score
    func setUpLabelOverBestScoreConstraint() {
        labelOverBestScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelOverBestScore.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            labelOverBestScore.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            labelOverBestScore.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelOverBestScore.bottomAnchor.constraint(equalTo: bestScoreLabel.topAnchor, constant: -20)
            ])
    }
    
    //MARK: -> Set Up Past Simple Label
    func setUpPastSimpleLabelConstraint() {
        pastSimpleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pastSimpleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pastSimpleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
    
    //MARK: -> Set Up Infinitive Label
    func setUpInfinitiveLabelConstraint() {
        infinitiveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infinitiveLabel.bottomAnchor.constraint(equalTo: pastSimpleLabel.topAnchor, constant: -Constants.distanceBetweenElements),
            infinitiveLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
    
    //MARK: -> Set Up Past Perfect Label
    func setUpPastPerfectLabelConstraint() {
        pastPerfectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pastPerfectLabel.topAnchor.constraint(equalTo: pastSimpleLabel.bottomAnchor, constant: Constants.distanceBetweenElements),
            pastPerfectLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
    
    //MARK: -> Set Up Field For Write Verb
    func setUpFieldForWriteVerb() {
        fieldForWriteVerb.font = UIFont(name: Constants.fontName, size: Constants.fontSizeMedium)
        fieldForWriteVerb.textColor = UIColor(named: Constants.projectColor)
        fieldForWriteVerb.tintColor = UIColor(named: Constants.projectColor)
        fieldForWriteVerb.layer.borderColor = UIColor(named: Constants.projectColor)?.cgColor
        fieldForWriteVerb.layer.borderWidth = 3
        fieldForWriteVerb.isHidden = true
        fieldForWriteVerb.textAlignment = .center
        fieldForWriteVerb.autocapitalizationType = UITextAutocapitalizationType.none
        self.view.addSubview(fieldForWriteVerb)
    }
    
    func setUpFieldForWriteVerbConstraint() {
        fieldForWriteVerb.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fieldForWriteVerb.topAnchor.constraint(equalTo: pastPerfectLabel.bottomAnchor, constant: 60),
            fieldForWriteVerb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fieldForWriteVerb.heightAnchor.constraint(equalToConstant: 55),
            fieldForWriteVerb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.fieldLeadingMargin),
            fieldForWriteVerb.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.fieldTrailingMargin)
            ])
    }
    
    //MARK: -> Set Up Next Button
    func setUpNextButtonConstraint() {
        nextVerb.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextVerb.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            nextVerb.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            nextVerb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextVerb.topAnchor.constraint(equalTo: fieldForWriteVerb.bottomAnchor, constant: Constants.distanceBetweenElements)
            ])
    }
    
    //MARK: -> Set Up Timer Label
    func setUpTimerLabelConstraint() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            timerLabel.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            timerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -80),
            timerLabel.bottomAnchor.constraint(equalTo: infinitiveLabel.topAnchor, constant: -60)
            ])
    }
    
    //MARK: -> Set Up Score Label
    func setUpScoreLabelConstraint() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            scoreLabel.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 80),
            scoreLabel.bottomAnchor.constraint(equalTo: infinitiveLabel.topAnchor, constant: -60)
            ])
    }
    
    //MARK: -> Set Up Label Over Timer
    func setUpLabelOverTimerConstraint() {
        labelOverTime.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelOverTime.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            labelOverTime.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            labelOverTime.centerXAnchor.constraint(equalTo: timerLabel.centerXAnchor),
            labelOverTime.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -20)
            ])
    }
    
    //MARK: -> Set Up Label Over Score
    func setUpLabelOverScoreConstraint() {
        labelOverScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelOverScore.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            labelOverScore.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            labelOverScore.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor),
            labelOverScore.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -20)
            ])
    }
    
    func scoreUpdate() {
        bestScoreLabel.text = String(presenter.bestScore)
    }
    
    //MARK: -> Buttons & Actions
    @objc func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goToNextVerb(_ sender: Any) {
        if fieldForWriteVerb.text == currentEmptyVerb {
            fieldForWriteVerb.text = ""
            logicOfGame()
            time += 5
            timerLabel.text = String(time)
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    @objc func startLearning(_ sender: Any) {
        time = 60
        score = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionForTimer), userInfo: nil, repeats: true)
        startGame.isHidden = true
        bestScoreLabel.isHidden = true
        labelOverBestScore.isHidden = true
        nextVerb.isHidden = false
        fieldForWriteVerb.isHidden = false
        timerLabel.isHidden = false
        scoreLabel.isHidden = false
        labelOverTime.isHidden = false
        labelOverScore.isHidden = false
        pastSimpleLabel.isHidden = false
        infinitiveLabel.isHidden = false
        pastPerfectLabel.isHidden = false
        logicOfGame()
    }
    
    @objc func actionForTimer() {
        time -= 1
        timerLabel.text = String(time)
        if time == 0 {
            timer.invalidate()
            startGame.isHidden = false
            bestScoreLabel.isHidden = false
            labelOverBestScore.isHidden = false
            nextVerb.isHidden = true
            fieldForWriteVerb.isHidden = true
            pastSimpleLabel.isHidden = true
            infinitiveLabel.isHidden = true
            pastPerfectLabel.isHidden = true
            timerLabel.isHidden = true
            scoreLabel.isHidden = true
            labelOverTime.isHidden = true
            labelOverScore.isHidden = true
            fieldForWriteVerb.text = ""
            if score > presenter.bestScore {
                presenter.scoreServerUpdate()
                bestScoreLabel.text = String(presenter.bestScore)
            }
        }
    }
    
    func cut(stringToCut: String?) -> String {
        guard var string = stringToCut else { return "" }
        let index = string.firstIndex(of: " ") ?? string.endIndex
        string.removeSubrange(index..<string.endIndex)
        print(string)
        return string
    }
    
    //MARK: -> Learning Logic
    func logicOfGame() {
        let randomVerb: (IrregularVerb?, Int) = presenter.randomElement()
        infinitiveLabel.text = cut(stringToCut: randomVerb.0?.infinitive)
        pastSimpleLabel.text = cut(stringToCut: randomVerb.0?.pastSimple)
        pastPerfectLabel.text = cut(stringToCut: randomVerb.0?.pastParticiple)
        switch randomVerb.1 {
        case 1:
            infinitiveLabel.text = "?"
            currentEmptyVerb = cut(stringToCut: randomVerb.0?.infinitive)
        case 2:
            pastSimpleLabel.text = "?"
            currentEmptyVerb = cut(stringToCut: randomVerb.0?.pastSimple)
        default:
            pastPerfectLabel.text = "?"
            currentEmptyVerb = cut(stringToCut: randomVerb.0?.pastParticiple)
        }
    }
}

//MARK: -> Extensions
extension UILabel {
    func createWhiteBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
    }
}
