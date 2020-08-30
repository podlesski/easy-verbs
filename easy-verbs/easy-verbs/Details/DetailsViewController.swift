//
//  DetailsViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 3/1/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "projectColor2")
        
        setUpBackButton()
        setUpBackButtonConstraint()
        
        setUpDescriptionLabel()
        setUpDescriptionLabelConstraint()
        
        setUpStackView()
        setUpStackViewConstraint()
        
        setUpInfinitiveLabel()
        setUpInfinitiveLabelConstraint()
        
        setUpPastSimpleLabelLabel()
        setUpPastSimpleLabelLabelConstraint()
        
        setUpPastPerfectLabelLabel()
        setUpPastPerfectLabelLabelConstraint()
        
        setUpPronunciationButton()
        setUpPronunciationButtonConstraint()
        
        setUpFavoritesButton()
        setUpFavoritesButtonConstraint()

        downloadFavoriteVerbs()
    }
    
    //MARK: -> Set Up Back Button
    func setUpBackButton() {
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(named: "projectColor")
        backButton.backgroundColor = UIColor(named: "projectColor2")
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    func setUpBackButtonConstraint() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
    }
    
    //MARK: -> Set Up Description Label
    func setUpDescriptionLabel() {
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        descriptionLabel.contentMode = .left
        descriptionLabel.text = verbFromDelegate?.description
        descriptionLabel.wordWrap()
        self.view.addSubview(descriptionLabel)
    }
    
    func setUpDescriptionLabelConstraint() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    //MARK: -> Set Up Stack View
    func setUpStackView() {
        stackView.axis = .vertical
        stackView.spacing = 42
        self.view.addSubview(stackView)
    }
    
    func setUpStackViewConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        stackView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -50).isActive = true
    }
    
    //MARK: -> Set Up Infinitive Label
    func setUpInfinitiveLabel() {
        infinitiveLabel.textColor = UIColor(named: "projectColor")
        infinitiveLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        infinitiveLabel.contentMode = .left
        infinitiveLabel.text = verbFromDelegate?.infinitive
        infinitiveLabel.wordWrap()
        stackView.addArrangedSubview(infinitiveLabel)
    }
    
    func setUpInfinitiveLabelConstraint() {
        infinitiveLabel.translatesAutoresizingMaskIntoConstraints = false
        infinitiveLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        infinitiveLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
    }
    
    //MARK: -> Set Up Past Simple Label
    func setUpPastSimpleLabelLabel() {
        pastSimpleLabel.textColor = UIColor(named: "projectColor")
        pastSimpleLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        pastSimpleLabel.contentMode = .left
        pastSimpleLabel.text = verbFromDelegate?.pastSimple
        pastSimpleLabel.wordWrap()
        stackView.addArrangedSubview(pastSimpleLabel)
    }
    
    func setUpPastSimpleLabelLabelConstraint() {
        pastSimpleLabel.translatesAutoresizingMaskIntoConstraints = false
        pastSimpleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        pastSimpleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
    }
    
    //MARK: -> Set Up Past Perfect Label
    func setUpPastPerfectLabelLabel() {
        pastPerfectLabel.textColor = UIColor(named: "projectColor")
        pastPerfectLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        pastPerfectLabel.contentMode = .left
        pastPerfectLabel.text = verbFromDelegate?.pastParticiple
        pastPerfectLabel.wordWrap()
        stackView.addArrangedSubview(pastPerfectLabel)
    }
    
    func setUpPastPerfectLabelLabelConstraint() {
        pastPerfectLabel.translatesAutoresizingMaskIntoConstraints = false
        pastPerfectLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        pastPerfectLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
    }
    
    //MARK: -> Set Up Pronunciation Button
    func setUpPronunciationButton() {
        pronunciationButton.setTitle("PRONUN CIATION", for: .normal)
        pronunciationButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        pronunciationButton.setTitleColor(.white, for: .normal)
        pronunciationButton.titleLabel?.wordWrap()
        pronunciationButton.addTarget(self, action: #selector(soundButton), for: .touchUpInside)
        pronunciationButton.createBorderWhiteColor()
        pronunciationButton.highlightOfBorder()
        self.view.addSubview(pronunciationButton)
    }
    
    func setUpPronunciationButtonConstraint() {
        pronunciationButton.translatesAutoresizingMaskIntoConstraints = false
        pronunciationButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        pronunciationButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pronunciationButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        pronunciationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
    }
    
    //MARK: -> Set Up Favorites Button
    func setUpFavoritesButton() {
        favoritesButton.setTitle("FAVORITES", for: .normal)
        favoritesButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        favoritesButton.setTitleColor(.white, for: .normal)
        favoritesButton.titleLabel?.wordWrap()
        favoritesButton.addTarget(self, action: #selector(addToFavoritesButton), for: .touchUpInside)
        favoritesButton.createBorderWhiteColor()
        self.view.addSubview(favoritesButton)
    }
    
    func setUpFavoritesButtonConstraint() {
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        favoritesButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        favoritesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        favoritesButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
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
