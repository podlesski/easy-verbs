import UIKit
import FirebaseAuth

class SignUpView: UIViewController, SignUpViewProtocol {
    private let presenter: SignUpPresenterProtocol
    
    init(presenter: SignUpPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let emailTextField = UITextField()
    let emailLine = UIView()
    let passwordTextField = UITextField()
    let passwordLine = UIView()
    let learningLabel = UILabel()
    let signUpLabel = UILabel()
    let logoImage = UIImageView()
    @objc let createNewAccountButton = UIButton()
    @objc let backButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private struct Constants {
        static let secondProjectColor: String = "projectColor2"
        static let projectColor: String = "projectColor"
        static let fontName: String = "Roboto-Regular"
        static let fontBoldName: String = "Roboto-Bold"
        static let leadingMargin: CGFloat = 80.0
        static let fontSizeSecondLabel: CGFloat = 30.0
        static let fontSizeLabel: CGFloat = 40.0
        static let textHight: CGFloat = 50.0
        static let emailPlaceholder: String = "Email"
        static let passwordPlaceholder: String = "Password"
        static let secondLabelText: String = "to start learning"
        static let firstLabelText: String = "Sign up"
        static let logoName: String = "logo"
        static let secondButtonName: String = "Back to sign in"
        static let fontSizeSecondButton: CGFloat = 15.0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let contentHeight = logoImage.frame.height + signUpLabel.frame.height + learningLabel.frame.height + emailTextField.frame.height + passwordTextField.frame.height + createNewAccountButton.frame.height + 100
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewsConstraints()
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor(named: Constants.secondProjectColor)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        setUpEmailTextField()
        setUpEmailLine()
        setUpPasswordTextField()
        setUpPasswordLine()
        setUpLearningLabel()
        setUpSignUpLabel()
        setUpLogoImage()
        setUpNextButton()
        setUpBackButton()
    }
    
    func setUpViewsConstraints() {
        setUpScrollViewConstraint()
        setUpScrollContentConstraint()
        setUpEmailTextFieldConstraint()
        setUpEmailLineConstraint()
        setUpPasswordTextFieldConstraint()
        setUpPasswordLineConstraint()
        setUpLearningLabelConstraint()
        setUpSignUpLabelConstraint()
        setUpLogoImageConstraint()
        setUpNextButtonConstraint()
        setUpBackButtonConstraint()
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 800.0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    //MARK: -> Set Up Email Text Field
    func setUpEmailTextField() {
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.textColor = UIColor(named: Constants.projectColor)
        emailTextField.tintColor = UIColor(named: Constants.projectColor)
        contentView.addSubview(emailTextField)
    }
    
    func setUpEmailTextFieldConstraint() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.textHight),
            emailTextField.topAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    //MARK: -> Set Up Email Line
    func setUpEmailLine() {
        emailLine.backgroundColor = UIColor(named: Constants.projectColor)
        contentView.addSubview(emailLine)
    }
    
    func setUpEmailLineConstraint() {
        emailLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emailLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            emailLine.heightAnchor.constraint(equalToConstant: 2),
            emailLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor)
            ])
    }
    
    //MARK: -> Set Up Password Text Field
    func setUpPasswordTextField() {
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.textColor = UIColor(named: Constants.projectColor)
        passwordTextField.tintColor = UIColor(named: Constants.projectColor)
        contentView.addSubview(passwordTextField)
    }
    
    func setUpPasswordTextFieldConstraint() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textHight),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20)
            ])
    }
    
    //MARK: -> Set Up Password Line
    func setUpPasswordLine() {
        passwordLine.backgroundColor = UIColor(named: Constants.projectColor)
        contentView.addSubview(passwordLine)
    }
    
    func setUpPasswordLineConstraint() {
        passwordLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            passwordLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            passwordLine.heightAnchor.constraint(equalToConstant: 2),
            passwordLine.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor)
            ])
    }
    
    //MARK: -> Set Up Learning Label
    func setUpLearningLabel() {
        learningLabel.text = Constants.secondLabelText
        learningLabel.font = UIFont(name: Constants.fontName, size: Constants.fontSizeSecondLabel)
        learningLabel.textColor = UIColor(named: Constants.projectColor)
        contentView.addSubview(learningLabel)
    }
    
    func setUpLearningLabelConstraint() {
        learningLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            learningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            learningLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            learningLabel.heightAnchor.constraint(equalToConstant: Constants.textHight),
            learningLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -30)
            ])
    }
    
    //MARK: -> Set Up Sign Up Label
    func setUpSignUpLabel() {
        signUpLabel.text = Constants.firstLabelText
        signUpLabel.font = UIFont(name: Constants.fontBoldName, size: Constants.fontSizeLabel)
        signUpLabel.textColor = UIColor(named: Constants.projectColor)
        contentView.addSubview(signUpLabel)
    }
    
    func setUpSignUpLabelConstraint() {
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signUpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            signUpLabel.heightAnchor.constraint(equalToConstant: 100),
            signUpLabel.bottomAnchor.constraint(equalTo: learningLabel.topAnchor)
            ])
    }
    
    //MARK: -> Set Up Logo
    func setUpLogoImage() {
        logoImage.image = UIImage(named: Constants.logoName)
        logoImage.contentMode = .scaleAspectFit
        contentView.addSubview(logoImage)
    }
    
    func setUpLogoImageConstraint() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.bottomAnchor.constraint(equalTo: signUpLabel.topAnchor)
            ])
    }
    
    //MARK: -> Set Up Create New Account Button
    func setUpNextButton() {
        createNewAccountButton.backgroundColor = UIColor(named: Constants.projectColor)
        createNewAccountButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        createNewAccountButton.tintColor = UIColor(named: Constants.secondProjectColor)
        createNewAccountButton.addTarget(self, action: #selector(createNewAccountButtonDidTap), for: .touchUpInside)
        contentView.addSubview(createNewAccountButton)
    }
    
    func setUpNextButtonConstraint() {
        createNewAccountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createNewAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            createNewAccountButton.heightAnchor.constraint(equalToConstant: 65),
            createNewAccountButton.widthAnchor.constraint(equalToConstant: 110),
            createNewAccountButton.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: 50)
            ])
    }
    
    //MARK: -> Set Up Back Button
    func setUpBackButton() {
        backButton.setTitle(Constants.secondButtonName, for: .normal)
        backButton.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.fontSizeSecondButton)
        backButton.setTitleColor(UIColor(named: Constants.projectColor), for: .normal)
        backButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        contentView.addSubview(backButton)
    }
    
    func setUpBackButtonConstraint() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingMargin),
            backButton.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 30)
            ])
    }
    
    //MARK: -> Buttons Actions
    @objc func signUpButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func createNewAccountButtonDidTap(_ sender: Any) {
        guard var emailText = emailTextField.text else {
            showAlert(title: "Error", message: "Email is epmpty")
            return
        }
        guard var passwordText = passwordTextField.text else {
            showAlert(title: "Error", message: "Password is epmpty")
            return
        }
        
        guard emailText.isValidEmail() else {
            emailText = ""
            showAlert(title: "Error", message: "This is not a valid email. Please try again.")
            return
        }
        guard passwordText.isValidPassword() else {
            passwordText = ""
            showAlert(title: "Error", message: "Password must be more than 7 characters")
            return
        }
        presenter.createUser(email: emailText, password: passwordText)
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: -> Extensions
extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        if self.count >= 8 {
            return true
        } else {
            return false
        }
    }
}

extension SignUpView {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
}
