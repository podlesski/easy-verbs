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
    
    @IBAction func createNewAccountButton(_ sender: Any) {
        
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
                self.showAlert(title: "Error", message: "\(error?.localizedDescription)")
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
    
    
    @IBAction func backToSignInButton(_ sender: Any) {
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
