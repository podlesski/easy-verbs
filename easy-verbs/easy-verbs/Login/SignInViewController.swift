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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.placeHolderColor = UIColor(named: "projectColor")
        emailTextField.placeHolderColor = UIColor(named: "projectColor")
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
    
    @IBAction func goToSignUpButton(_ sender: Any) {
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

