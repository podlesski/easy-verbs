//
//  SignUpViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/7/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "projectColor2")
        
        self.setUpEmailTextField()
        self.setUpEmailTextFieldConstraint()
        
        self.setUpEmailLine()
        self.setUpEmailLineConstraint()
        
        self.setUpPasswordTextField()
        self.setUpPasswordTextFieldConstraint()
        
        self.setUpPasswordLine()
        self.setUpPasswordLineConstraint()
        
        self.setUpLearningLabel()
        self.setUpLearningLabelConstraint()
        
        self.setUpSignUpLabel()
        self.setUpSignUpLabelConstraint()
        
        self.setUpLogoImage()
        self.setUpLogoImageConstraint()
        
        self.setUpNextButton()
        self.setUpNextButtonConstraint()
        
        self.setUpSignUpButton()
        self.setUpSignUpButtonConstraint()
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
    
    //MARK: -> Set Up Learning Label
    func setUpLearningLabel() {
        self.learningLabel.text = "to start learning"
        self.learningLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        self.learningLabel.textColor = UIColor(named: "projectColor")
        self.view.addSubview(learningLabel)
    }
    
    func setUpLearningLabelConstraint() {
        self.learningLabel.translatesAutoresizingMaskIntoConstraints = false
        self.learningLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.learningLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.learningLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.learningLabel.bottomAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: -50).isActive = true
    }
    
    //MARK: -> Set Up Sign Up Label
    func setUpSignUpLabel() {
        self.signUpLabel.text = "Sign up"
        self.signUpLabel.font = UIFont(name: "Roboto-Bold", size: 40)
        self.signUpLabel.textColor = UIColor(named: "projectColor")
        self.view.addSubview(signUpLabel)
    }
    
    func setUpSignUpLabelConstraint() {
        self.signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        self.signUpLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.signUpLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.signUpLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.signUpLabel.bottomAnchor.constraint(equalTo: self.learningLabel.topAnchor).isActive = true
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
        self.logoImage.bottomAnchor.constraint(equalTo: self.signUpLabel.topAnchor).isActive = true
    }
    
    //MARK: -> Set Up Create New Account Button
    func setUpNextButton() {
        self.createNewAccountButton.backgroundColor = UIColor(named: "projectColor")
        self.createNewAccountButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        self.createNewAccountButton.tintColor = UIColor(named: "projectColor2")
        self.createNewAccountButton.addTarget(self, action: #selector(createNewAccountButtonDidTap), for: .touchUpInside)
        self.view.addSubview(createNewAccountButton)
    }
    
    func setUpNextButtonConstraint() {
        self.createNewAccountButton.translatesAutoresizingMaskIntoConstraints = false
        self.createNewAccountButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.createNewAccountButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        self.createNewAccountButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        self.createNewAccountButton.topAnchor.constraint(equalTo: self.passwordLine.bottomAnchor, constant: 50).isActive = true
    }
    
    //MARK: -> Set Up Back Button
    func setUpSignUpButton() {
        self.backButton.setTitle("Back to sign in", for: .normal)
        self.backButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        self.backButton.setTitleColor(UIColor(named: "projectColor"), for: .normal)
        self.backButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func setUpSignUpButtonConstraint() {
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.createNewAccountButton.bottomAnchor, constant: 50).isActive = true
    }
    
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
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { (authResult, error) in
            guard let authResult = authResult else { return }
            guard error == nil else {
                self.showAlert(title: "Error", message: "\(String(describing: error?.localizedDescription))")
                return
            }
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: [
                "email": emailText,
                "password": passwordText,
                "uid": authResult.user.uid,
                "bestScore": 0,
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

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

extension SignUpViewController {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
}
