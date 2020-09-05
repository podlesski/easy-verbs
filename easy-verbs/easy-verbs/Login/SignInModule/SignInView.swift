import UIKit
import FirebaseAuth

class SignInView: UIViewController, SignInViewProtocol {
    private let presenter: SignInPresenterProtocol
    
    init(presenter: SignInPresenterProtocol) {
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
    let signInLabel = UILabel()
    let welcomeLabel = UILabel()
    let logoImage = UIImageView()
    @objc let nextButton = UIButton()
    @objc let signUpButton = UIButton()
    
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
        static let secondLabelText: String = "sign in to continue"
        static let firstLabelText: String = "Welcome"
        static let logoName: String = "logo"
        static let secondButtonName: String = "New here? Sing up"
        static let fontSizeSecondButton: CGFloat = 15.0
        
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
        setUpEmailTextField()
        setUpEmailLine()
        setUpPasswordTextField()
        setUpPasswordLine()
        setUpSignInLabel()
        setUpSignInLabel()
        setUpWelcomeLabel()
        setUpLogoImage()
        setUpNextButton()
        setUpSignUpButton()
    }
    
    func setUpViewsConstraints() {
        setUpEmailTextFieldConstraint()
        setUpEmailLineConstraint()
        setUpPasswordTextFieldConstraint()
        setUpPasswordLineConstraint()
        setUpSignInLabelConstraint()
        setUpWelcomeLabelConstraint()
        setUpLogoImageConstraint()
        setUpNextButtonConstraint()
        setUpSignUpButtonConstraint()
    }
    
    //MARK: -> Set Up Email Text Field
    func setUpEmailTextField() {
        emailTextField.placeholder = Constants.emailPlaceholder
        emailTextField.textColor = UIColor(named: Constants.projectColor)
        emailTextField.tintColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(emailTextField)
    }
    
    func setUpEmailTextFieldConstraint() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            emailTextField.heightAnchor.constraint(equalToConstant: Constants.textHight),
            emailTextField.topAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
    }
    
    //MARK: -> Set Up Email Line
    func setUpEmailLine() {
        emailLine.backgroundColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(emailLine)
    }
    
    func setUpEmailLineConstraint() {
        emailLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            emailLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            emailLine.heightAnchor.constraint(equalToConstant: 2),
            emailLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor)
            ])
    }
    
    //MARK: -> Set Up Password Text Field
    func setUpPasswordTextField() {
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.textColor = UIColor(named: Constants.projectColor)
        passwordTextField.tintColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(passwordTextField)
    }
    
    func setUpPasswordTextFieldConstraint() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textHight),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20)
            ])
    }
    
    //MARK: -> Set Up Password Line
    func setUpPasswordLine() {
        passwordLine.backgroundColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(passwordLine)
    }
    
    func setUpPasswordLineConstraint() {
        passwordLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            passwordLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            passwordLine.heightAnchor.constraint(equalToConstant: 2),
            passwordLine.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor)
            ])
    }
    
    //MARK: -> Set Up Sign In Label
    func setUpSignInLabel() {
        signInLabel.text = Constants.secondLabelText
        signInLabel.font = UIFont(name: Constants.fontName, size: Constants.fontSizeSecondLabel)
        signInLabel.textColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(signInLabel)
    }
    
    func setUpSignInLabelConstraint() {
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            signInLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            signInLabel.heightAnchor.constraint(equalToConstant: Constants.textHight),
            signInLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -50)
            ])
    }
    
    //MARK: -> Set Up Welcome Label
    func setUpWelcomeLabel() {
        welcomeLabel.text = Constants.firstLabelText
        welcomeLabel.font = UIFont(name: Constants.fontBoldName, size: Constants.fontSizeLabel)
        welcomeLabel.textColor = UIColor(named: Constants.projectColor)
        self.view.addSubview(welcomeLabel)
    }
    
    func setUpWelcomeLabelConstraint() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 100),
            welcomeLabel.bottomAnchor.constraint(equalTo: signInLabel.topAnchor)
            ])
    }
    
    //MARK: -> Set Up Logo
    func setUpLogoImage() {
        logoImage.image = UIImage(named: Constants.logoName)
        logoImage.contentMode = .scaleAspectFit
        self.view.addSubview(logoImage)
    }
    
    func setUpLogoImageConstraint() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor)
            ])
    }
    
    //MARK: -> Set Up Next Button
    func setUpNextButton() {
        nextButton.backgroundColor = UIColor(named: Constants.projectColor)
        nextButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        nextButton.tintColor = UIColor(named: Constants.secondProjectColor)
        nextButton.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
        self.view.addSubview(nextButton)
    }
    
    func setUpNextButtonConstraint() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            nextButton.heightAnchor.constraint(equalToConstant: 65),
            nextButton.widthAnchor.constraint(equalToConstant: 110),
            nextButton.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: 50)
            ])
    }
    
    //MARK: -> Set Up Sign Up Button
    func setUpSignUpButton() {
        signUpButton.setTitle(Constants.secondButtonName, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.fontSizeSecondButton)
        signUpButton.setTitleColor(UIColor(named: Constants.projectColor), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        self.view.addSubview(signUpButton)
    }
    
    func setUpSignUpButtonConstraint() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.leadingMargin),
            signUpButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 50)
            ])
    }
    
    //MARK: -> Buttons Actions
    @objc func signUpButtonDidTap() {
        let signUpViewController = SignUpFactory.make()
        signUpViewController.modalPresentationStyle = .fullScreen
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    @objc func loginButton(_ sender: Any) {
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
        guard presenter.authState(email: emailText, password: passwordText) else {
            showAlert(title: "Error", message: "This user does not exist.")
            return
        }
        
        let menuViewController = MenuFactory.make()
        menuViewController.modalPresentationStyle = .fullScreen
        self.present(menuViewController, animated: true, completion: nil)
    }
}

//MARK: -> Extensions
extension SignInView {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!.withAlphaComponent(0.3)])
        }
    }
}
