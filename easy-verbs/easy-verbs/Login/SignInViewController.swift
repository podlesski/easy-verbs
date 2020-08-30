//
//  ViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/6/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {
    
    let emailTextField = UITextField()
    let emailLine = UIView()
    let passwordTextField = UITextField()
    let passwordLine = UIView()
    let signInLabel = UILabel()
    let welcomeLabel = UILabel()
    let logoImage = UIImageView()
    let nextButton = UIButton()
    @objc let signUpButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpEmailTextField()
        self.setUpEmailTextFieldConstraint()
        
        self.setUpEmailLine()
        self.setUpEmailLineConstraint()
        
        self.setUpPasswordTextField()
        self.setUpPasswordTextFieldConstraint()
        
        self.setUpPasswordLine()
        self.setUpPasswordLineConstraint()
        
        self.setUpSignInLabel()
        self.setUpSignInLabelConstraint()
        
        self.setUpWelcomeLabel()
        self.setUpWelcomeLabelConstraint()
        
        self.setUpLogoImage()
        self.setUpLogoImageConstraint()
        
        self.setUpNextButton()
        self.setUpNextButtonConstraint()
        
        self.setUpSignUpButton()
        self.setUpSignUpButtonConstraint()
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        
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
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.showAlert(title: "Error", message: "This user does not exist.")
                return
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        menuVC.modalPresentationStyle = .fullScreen
        present(menuVC, animated: true, completion: nil)
    }
    
    //MARK: -> Set Up Email Text Field
    func setUpEmailTextField() {
        self.emailTextField.placeholder = "Email"
        self.emailTextField.textColor = UIColor(named: "projectColor")
        self.emailTextField.tintColor = UIColor(named: "projectColor")
        self.view.addSubview(self.emailTextField)
    }
    
    func setUpEmailTextFieldConstraint() {
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.emailTextField.topAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    //MARK: -> Set Up Email Line
    func setUpEmailLine() {
        self.emailLine.backgroundColor = UIColor(named: "projectColor")
        self.view.addSubview(emailLine)
    }
    
    func setUpEmailLineConstraint() {
        self.emailLine.translatesAutoresizingMaskIntoConstraints = false
        self.emailLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.emailLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.emailLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.emailLine.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor).isActive = true
    }
    
    //MARK: -> Set Up Password Text Field
    func setUpPasswordTextField() {
        self.passwordTextField.placeholder = "Password"
        self.passwordTextField.textColor = UIColor(named: "projectColor")
        self.passwordTextField.tintColor = UIColor(named: "projectColor")
        self.view.addSubview(self.passwordTextField)
    }
    
    func setUpPasswordTextFieldConstraint() {
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
    }
    
    //MARK: -> Set Up Password Line
    func setUpPasswordLine() {
        self.passwordLine.backgroundColor = UIColor(named: "projectColor")
        self.view.addSubview(passwordLine)
    }
    
    func setUpPasswordLineConstraint() {
        self.passwordLine.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.passwordLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.passwordLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.passwordLine.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor).isActive = true
    }
    
    //MARK: -> Set Up Sign In Label
    func setUpSignInLabel() {
        self.signInLabel.text = "sign in to continue"
        self.signInLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        self.signInLabel.textColor = UIColor(named: "projectColor")
        self.view.addSubview(signInLabel)
    }
    
    func setUpSignInLabelConstraint() {
        self.signInLabel.translatesAutoresizingMaskIntoConstraints = false
        self.signInLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.signInLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.signInLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.signInLabel.bottomAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: -50).isActive = true
    }
    
    //MARK: -> Set Up Welcome Label
    func setUpWelcomeLabel() {
        self.welcomeLabel.text = "Welcome"
        self.welcomeLabel.font = UIFont(name: "Roboto-Bold", size: 40)
        self.welcomeLabel.textColor = UIColor(named: "projectColor")
        self.view.addSubview(welcomeLabel)
    }
    
    func setUpWelcomeLabelConstraint() {
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.welcomeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.welcomeLabel.bottomAnchor.constraint(equalTo: self.signInLabel.topAnchor).isActive = true
    }
    
    //MARK: -> Set Up Logo
    func setUpLogoImage() {
        self.logoImage.image = UIImage(named: "logo")
        self.logoImage.contentMode = .scaleAspectFit
        self.view.addSubview(logoImage)
    }
    
    func setUpLogoImageConstraint() {
        self.logoImage.translatesAutoresizingMaskIntoConstraints = false
        self.logoImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.logoImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.logoImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.logoImage.bottomAnchor.constraint(equalTo: self.welcomeLabel.topAnchor).isActive = true
    }
    
    //MARK: -> Set Up Next Button
    func setUpNextButton() {
        self.nextButton.backgroundColor = UIColor(named: "projectColor")
        self.nextButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        self.nextButton.tintColor = UIColor(named: "projectColor2")
        self.view.addSubview(nextButton)
    }
    
    func setUpNextButtonConstraint() {
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        self.nextButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        self.nextButton.topAnchor.constraint(equalTo: self.passwordLine.bottomAnchor, constant: 50).isActive = true
    }
    
    //MARK: -> Set Up Sign Up Button
    func setUpSignUpButton() {
        signUpButton.setTitle("New here? Sing up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        signUpButton.setTitleColor(UIColor(named: "projectColor"), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        self.view.addSubview(signUpButton)
    }
    
    func setUpSignUpButtonConstraint() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.signUpButton.topAnchor.constraint(equalTo: self.nextButton.bottomAnchor, constant: 50).isActive = true
    }
    
    @objc func signUpButtonDidTap() {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .fullScreen
        self.present(signUpViewController, animated: true, completion: nil)
    }
}

//MARK: -> Extensions
extension SignInViewController {
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
