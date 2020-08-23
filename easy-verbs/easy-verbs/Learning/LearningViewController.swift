//
//  LearningViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 3/7/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import Firebase

class LearningViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let storage = Storage.storage().reference()
    let db  = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    var allVerbs = [IrregularVerb]()
    
    @IBOutlet weak var timerLabel: UILabel!
    var time = 60
    var timer = Timer()
    
    @IBOutlet weak var infinitiveLabel: UILabel!
    @IBOutlet weak var pastSimpleLabel: UILabel!
    @IBOutlet weak var pastPerfectLabel: UILabel!
    @IBOutlet weak var labelsForGame: UIStackView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var labelUnderTime: UILabel!
    @IBOutlet weak var labelUnderScore: UILabel!
    @IBOutlet weak var bestScoreAndBorder: UIStackView!
    
    
    
    @IBOutlet weak var scoreAndTime: UIStackView!
    
    var currentEmptyVerb: String?
    var score = 0
    
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    var bestScore = Int()
    
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var fieldForWriteVerb: UITextField!
    @IBOutlet weak var nextVerb: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelsForGame.isHidden = true
        nextVerb.isHidden = true
        fieldForWriteVerb.isHidden = true
        scoreAndTime.isHidden = true
        
        fieldForWriteVerb.layer.borderColor = UIColor(named:"projectColor")?.cgColor
        fieldForWriteVerb.layer.borderWidth = 3
        
        bestScoreFromFirebase()
        
        scoreLabel.createWhiteBorder()
        timerLabel.createWhiteBorder()
        bestScoreLabel.createWhiteBorder()
       
        
        
        
        // MARK: -> Loading JSON
        
        let allVerbsRef = storage.child("easy_verbs.json")
        
        allVerbsRef.getData(maxSize: Int64.max) { [weak self] (data, error) in
            guard error == nil else { return }
            guard let self = self else { return }
            guard let data = data else { return }
                                
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode([IrregularVerb].self, from: data)
                print(json)
                DispatchQueue.main.async {
                self.allVerbs = json
                }
            } catch let error {
                print(error)
            }
        }

    }
    
    //MARK: -> Download the best score
    
    func bestScoreFromFirebase() {
    guard let user = userID else { return }
    
    db.collection("users").whereField("uid", isEqualTo: user)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    DispatchQueue.main.async {
                        print("\(document.documentID) => \(document.data())")
                        self.bestScore = document.data()["bestScore"] as? Int ?? 0
                        self.bestScoreLabel.text = String(self.bestScore)
                        print(self.bestScore)
                    }
                }
            }
        }
    }
    
    //MARK: -> Update the best score
    
    func updateBestScore() {
        guard let user = userID else { return }

        db.collection("users").whereField("uid", isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        document.reference.updateData(["bestScore" : self.bestScore])
                        print(self.bestScore)
                    }
                }
        }
    }
    
    //MARK: -> Buttons & Actions
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goToNextVerb(_ sender: Any) {
        if fieldForWriteVerb.text == currentEmptyVerb {
            fieldForWriteVerb.text = ""
            logicOfGame()
            time += 5
            timerLabel.text = String(time)
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    @IBAction func startLearning(_ sender: Any) {
        time = 60
        score = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionForTimer), userInfo: nil, repeats: true)
        startGame.isHidden = true
        nextVerb.isHidden = false
        fieldForWriteVerb.isHidden = false
        scoreAndTime.isHidden = false
        bestScoreAndBorder.isHidden = true
        logicOfGame()
        
        
        
    }
    
    @objc func actionForTimer() {
        time -= 1
        timerLabel.text = String(time)
        if time == 0 {
            timer.invalidate()
            startGame.isHidden = false
            nextVerb.isHidden = true
            fieldForWriteVerb.isHidden = true
            labelsForGame.isHidden = true
            scoreAndTime.isHidden = true
            bestScoreAndBorder.isHidden = false
            fieldForWriteVerb.text = ""
            
            if score > bestScore {
                bestScore = score
                bestScoreLabel.text = String(bestScore)
                updateBestScore()
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
        let random = Int.random(in: 1...3)
        let randomVerb = allVerbs.randomElement()
        
        infinitiveLabel.text = cut(stringToCut: randomVerb?.infinitive)
        pastSimpleLabel.text = cut(stringToCut: randomVerb?.pastSimple)
        pastPerfectLabel.text = cut(stringToCut: randomVerb?.pastParticiple)
        
        switch random {
        case 1:
            infinitiveLabel.text = "?"
            currentEmptyVerb = cut(stringToCut: randomVerb?.infinitive)
        case 2:
            pastSimpleLabel.text = "?"
            currentEmptyVerb = cut(stringToCut: randomVerb?.pastSimple)
        default:
            pastPerfectLabel.text = "?"
            currentEmptyVerb = cut(stringToCut: randomVerb?.pastParticiple)
        }
        
        labelsForGame.isHidden = false
    }
    
}


//MARK: -> Extensions

extension UILabel {
    func createWhiteBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
    }
}


