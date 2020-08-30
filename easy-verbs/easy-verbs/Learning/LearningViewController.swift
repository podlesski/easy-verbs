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
    var time = 60
    var timer = Timer()
    var currentEmptyVerb: String?
    var score = 0
    var bestScore = Int()
    
    //MARK: -> Game UI Elements
    let labelUnderTime = UILabel()
    let timerLabel = UILabel()
    let labelUnderScore = UILabel()
    let scoreLabel = UILabel()
    let infinitiveLabel = UILabel()
    let pastSimpleLabel = UILabel()
    let pastPerfectLabel = UILabel()
    let fieldForWriteVerb = UITextField()
    let nextVerb = UIButton()
    let skipVerb = UIButton()
    
    //MARK: -> Start UI Elements
    let backButton = UIButton()
    let labelUnderBestScore = UILabel()
    let bestScoreLabel = UILabel()
    let startGame = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "projectColor2")
        
        setUpBackButton()
        setUpBackButtonConstraint()
        
        setUpStartGameButton()
        setUpStartGameButtonConstraint()
        
        setUpBestScoreLabel()
        setUpBestScoreLabelConstraint()
        
        setUpLabelOverBestScore()
        setUpLabelOverBestScoreConstraint()
        
        setUpPastSimpleLabel()
        setUpPastSimpleLabelConstraint()
        
        setUpInfinitiveLabel()
        setUpInfinitiveLabelConstraint()
        
        setUpPastPerfectLabel()
        setUpPastPerfectLabelConstraint()
        
        setUpFieldForWriteVerb()
        setUpFieldForWriteVerbConstraint()
        
        setUpNextButton()
        setUpNextButtonConstraint()
        
        setUpTimerLabel()
        setUpTimerLabelConstraint()
        
        setUpScoreLabel()
        setUpScoreLabelConstraint()
        
        setUpLabelOverTimer()
        setUpLabelOverTimerConstraint()
        
        setUpLabelOverScore()
        setUpLabelOverScoreConstraint()
        
        bestScoreFromFirebase()
       
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
    
    //MARK: -> Set Up Start Game Button
    func setUpStartGameButton() {
        startGame.setTitle("START", for: .normal)
        startGame.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        startGame.setTitleColor(UIColor(named: "projectColor2"), for: .normal)
        startGame.backgroundColor = UIColor(named: "projectColor")
        startGame.addTarget(self, action: #selector(startLearning), for: .touchUpInside)
        self.view.addSubview(startGame)
    }
    
    func setUpStartGameButtonConstraint() {
        startGame.translatesAutoresizingMaskIntoConstraints = false
        startGame.heightAnchor.constraint(equalToConstant: 65).isActive = true
        startGame.widthAnchor.constraint(equalToConstant: 100).isActive = true
        startGame.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startGame.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //MARK: -> Set Up Best Score Label
    func setUpBestScoreLabel() {
        bestScoreLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        bestScoreLabel.textColor = .white
        bestScoreLabel.textAlignment = .center
        bestScoreLabel.createWhiteBorder()
        self.view.addSubview(bestScoreLabel)
    }
    
    func setUpBestScoreLabelConstraint() {
        bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        bestScoreLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true
        bestScoreLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        bestScoreLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bestScoreLabel.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -100).isActive = true
    }
    
    //MARK: -> Set Up Label Over Best Score
    func setUpLabelOverBestScore() {
        labelUnderBestScore.font = UIFont(name: "Roboto-Bold", size: 17)
        labelUnderBestScore.textColor = .white
        labelUnderBestScore.text = "BEST SCORE"
        self.view.addSubview(labelUnderBestScore)
    }
    
    func setUpLabelOverBestScoreConstraint() {
        labelUnderBestScore.translatesAutoresizingMaskIntoConstraints = false
        labelUnderBestScore.heightAnchor.constraint(equalToConstant: 65).isActive = true
        labelUnderBestScore.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelUnderBestScore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        labelUnderBestScore.bottomAnchor.constraint(equalTo: bestScoreLabel.topAnchor, constant: -20).isActive = true
    }
    
    //MARK: -> Set Up Past Simple Label
    func setUpPastSimpleLabel() {
        pastSimpleLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        pastSimpleLabel.textColor = UIColor(named: "projectColor")
        pastSimpleLabel.isHidden = true
        self.view.addSubview(pastSimpleLabel)
    }
    
    func setUpPastSimpleLabelConstraint() {
        pastSimpleLabel.translatesAutoresizingMaskIntoConstraints = false
        pastSimpleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        pastSimpleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //MARK: -> Set Up Infinitive Label
    func setUpInfinitiveLabel() {
        infinitiveLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        infinitiveLabel.textColor = UIColor(named: "projectColor")
        infinitiveLabel.isHidden = true
        self.view.addSubview(infinitiveLabel)
    }
    
    func setUpInfinitiveLabelConstraint() {
        infinitiveLabel.translatesAutoresizingMaskIntoConstraints = false
        infinitiveLabel.bottomAnchor.constraint(equalTo: pastSimpleLabel.topAnchor, constant: -50).isActive = true
        infinitiveLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //MARK: -> Set Up Past Perfect Label
    func setUpPastPerfectLabel() {
        pastPerfectLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        pastPerfectLabel.textColor = UIColor(named: "projectColor")
        pastPerfectLabel.isHidden = true
        self.view.addSubview(pastPerfectLabel)
    }
    
    func setUpPastPerfectLabelConstraint() {
        pastPerfectLabel.translatesAutoresizingMaskIntoConstraints = false
        pastPerfectLabel.topAnchor.constraint(equalTo: pastSimpleLabel.bottomAnchor, constant: 50).isActive = true
        pastPerfectLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //MARK: -> Set Up Field For Write Verb
    func setUpFieldForWriteVerb() {
        fieldForWriteVerb.font = UIFont(name: "Roboto-Bold", size: 17)
        fieldForWriteVerb.textColor = UIColor(named:"projectColor")
        fieldForWriteVerb.tintColor = UIColor(named:"projectColor")
        fieldForWriteVerb.layer.borderColor = UIColor(named:"projectColor")?.cgColor
        fieldForWriteVerb.layer.borderWidth = 3
        fieldForWriteVerb.isHidden = true
        fieldForWriteVerb.textAlignment = .center
        fieldForWriteVerb.autocapitalizationType = UITextAutocapitalizationType.none
        self.view.addSubview(fieldForWriteVerb)
    }
    
    func setUpFieldForWriteVerbConstraint() {
        fieldForWriteVerb.translatesAutoresizingMaskIntoConstraints = false
        fieldForWriteVerb.topAnchor.constraint(equalTo: pastPerfectLabel.bottomAnchor, constant: 60).isActive = true
        fieldForWriteVerb.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fieldForWriteVerb.heightAnchor.constraint(equalToConstant: 55).isActive = true
        fieldForWriteVerb.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100).isActive = true
        fieldForWriteVerb.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100).isActive = true
    }
    
    //MARK: -> Set Up Next Button
    func setUpNextButton() {
        nextVerb.isHidden = true
        nextVerb.setTitle("NEXT", for: .normal)
        nextVerb.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        nextVerb.setTitleColor(UIColor(named: "projectColor2"), for: .normal)
        nextVerb.backgroundColor = UIColor(named: "projectColor")
        nextVerb.addTarget(self, action: #selector(goToNextVerb), for: .touchUpInside)
        self.view.addSubview(nextVerb)
    }
    
    func setUpNextButtonConstraint() {
        nextVerb.translatesAutoresizingMaskIntoConstraints = false
        nextVerb.heightAnchor.constraint(equalToConstant: 65).isActive = true
        nextVerb.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextVerb.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        nextVerb.topAnchor.constraint(equalTo: fieldForWriteVerb.bottomAnchor, constant: 50).isActive = true
    }
    
    //MARK: -> Set Up Timer Label
    func setUpTimerLabel() {
        timerLabel.isHidden = true
        timerLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        timerLabel.createWhiteBorder()
        self.view.addSubview(timerLabel)
    }
    
    func setUpTimerLabelConstraint() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -80).isActive = true
        timerLabel.bottomAnchor.constraint(equalTo: infinitiveLabel.topAnchor, constant: -60).isActive = true
    }
    
    //MARK: -> Set Up Score Label
    func setUpScoreLabel() {
        scoreLabel.isHidden = true
        scoreLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.text = "0"
        scoreLabel.createWhiteBorder()
        self.view.addSubview(scoreLabel)
    }
    
    func setUpScoreLabelConstraint() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 80).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: infinitiveLabel.topAnchor, constant: -60).isActive = true
    }
    
    //MARK: -> Set Up Label Over Timer
    func setUpLabelOverTimer() {
        labelUnderTime.isHidden = true
        labelUnderTime.font = UIFont(name: "Roboto-Bold", size: 17)
        labelUnderTime.textColor = .white
        labelUnderTime.text = "TIME"
        labelUnderTime.textAlignment = .center
        self.view.addSubview(labelUnderTime)
    }
    
    func setUpLabelOverTimerConstraint() {
        labelUnderTime.translatesAutoresizingMaskIntoConstraints = false
        labelUnderTime.heightAnchor.constraint(equalToConstant: 65).isActive = true
        labelUnderTime.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelUnderTime.centerXAnchor.constraint(equalTo: timerLabel.centerXAnchor).isActive = true
        labelUnderTime.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -20).isActive = true
    }
    
    //MARK: -> Set Up Label Over Score
    func setUpLabelOverScore() {
        labelUnderScore.isHidden = true
        labelUnderScore.font = UIFont(name: "Roboto-Bold", size: 17)
        labelUnderScore.textColor = .white
        labelUnderScore.text = "SCORE"
        labelUnderScore.textAlignment = .center
        self.view.addSubview(labelUnderScore)
    }
    
    func setUpLabelOverScoreConstraint() {
        labelUnderScore.translatesAutoresizingMaskIntoConstraints = false
        labelUnderScore.heightAnchor.constraint(equalToConstant: 65).isActive = true
        labelUnderScore.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelUnderScore.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor).isActive = true
        labelUnderScore.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -20).isActive = true
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
        labelUnderBestScore.isHidden = true
        nextVerb.isHidden = false
        fieldForWriteVerb.isHidden = false
        timerLabel.isHidden = false
        scoreLabel.isHidden = false
        labelUnderTime.isHidden = false
        labelUnderScore.isHidden = false
        logicOfGame()
    }
    
    @objc func actionForTimer() {
        time -= 1
        timerLabel.text = String(time)
        if time == 0 {
            timer.invalidate()
            startGame.isHidden = false
            bestScoreLabel.isHidden = false
            labelUnderBestScore.isHidden = false
            nextVerb.isHidden = true
            fieldForWriteVerb.isHidden = true
            pastSimpleLabel.isHidden = true
            infinitiveLabel.isHidden = true
            pastPerfectLabel.isHidden = true
            timerLabel.isHidden = true
            scoreLabel.isHidden = true
            labelUnderTime.isHidden = true
            labelUnderScore.isHidden = true
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
        pastSimpleLabel.isHidden = false
        infinitiveLabel.isHidden = false
        pastPerfectLabel.isHidden = false
    }
}

//MARK: -> Extensions
extension UILabel {
    func createWhiteBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
    }
}
