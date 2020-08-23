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
    
    
    //MARK: -> Outlets
    
    @IBOutlet weak var infinitiveLabel: UILabel!
    @IBOutlet weak var pastSimpleLabel: UILabel!
    @IBOutlet weak var pastPerfectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pronunciationButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var favoritesVerbs = [String]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent

    }

    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pronunciationButton.createBorderWhiteColor()
        pronunciationButton.highlightOfBorder()
        favoritesButton.createBorderWhiteColor()
        downloadFavoriteVerbs()
        update()
        

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
    
    @IBAction func soundButton(_ sender: Any) {
        guard let url = soundURL() else { return }
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: url)
             audioPlayer.play()
        } catch {
           // Alert?
        }
    }
    
    @IBAction func addToFavoritesButton(_ sender: Any) {
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
    
    func update() {
        infinitiveLabel.text = verbFromDelegate?.infinitive
        pastSimpleLabel.text = verbFromDelegate?.pastSimple
        pastPerfectLabel.text = verbFromDelegate?.pastParticiple
        descriptionLabel.text = verbFromDelegate?.description
        
        infinitiveLabel.wordWrap()
        pastSimpleLabel.wordWrap()
        pastPerfectLabel.wordWrap()
        descriptionLabel.wordWrap()
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
    
    
    @IBAction func backButton(_ sender: Any) {
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
