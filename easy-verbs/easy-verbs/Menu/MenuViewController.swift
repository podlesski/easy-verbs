//
//  MenuViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/9/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let background = UIView()
    let buttonTableView = UITableView()
    let appNameLabel = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "projectColor2")
        
        setUpBackground()
        setUpBackgroundConstraint()
        
        setUpAppNameLabel()
        setUpAppNameLabelConstraint()
        
        setUpButtonTableView()
        setUpButtonTableViewConstraint()
    }
    
    //MARK: -> Set Up Background
    func setUpBackground() {
        background.backgroundColor = UIColor(named: "projectColor2")
        self.view.addSubview(background)
    }
    
    func setUpBackgroundConstraint() {
        self.background.translatesAutoresizingMaskIntoConstraints = false
        self.background.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.background.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.background.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.background.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 280).isActive = true
    }
    
    //MARK: -> Set Up App Name Label
    func setUpAppNameLabel() {
        appNameLabel.text = "EASY VERBS"
        appNameLabel.textColor = UIColor(named: "projectColor")
        appNameLabel.font = UIFont(name: "Roboto-Bold", size: 48)
        appNameLabel.lineBreakMode = .byWordWrapping
        appNameLabel.numberOfLines = 2
        appNameLabel.textAlignment = .center
        appNameLabel.backgroundColor = .clear
        appNameLabel.layer.borderWidth = 4
        appNameLabel.layer.borderColor = UIColor(named:"projectColor")?.cgColor
        self.view.addSubview(appNameLabel)
    }
    
    func setUpAppNameLabelConstraint() {
        self.appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.appNameLabel.heightAnchor.constraint(equalToConstant: 180).isActive = true
        self.appNameLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        self.appNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.appNameLabel.centerYAnchor.constraint(equalTo: self.background.centerYAnchor, constant: 20).isActive = true
    }
    
    //MARK: -> Set Up Button Table View
    func setUpButtonTableView() {
        buttonTableView.rowHeight = 200
        buttonTableView.dataSource = self
        buttonTableView.delegate = self
        buttonTableView.separatorStyle = .none
        buttonTableView.backgroundColor = UIColor(named: "projectColor2")
        self.view.addSubview(buttonTableView)
    }
    
    func setUpButtonTableViewConstraint() {
        self.buttonTableView.translatesAutoresizingMaskIntoConstraints = false
        self.buttonTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.buttonTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.buttonTableView.topAnchor.constraint(equalTo: self.background.bottomAnchor).isActive = true
        self.buttonTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

//MARK: -> Extensions
extension UIButton {
    func addColorBorder() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(named: "projectColor")?.cgColor
    }
}

extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buttonsOnMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ButtonTableViewCell()
        cell.delegate = self
        cell.update(with: buttonsOnMenu[indexPath.row])
        return cell
    }
    
}

extension MenuViewController: ButtonTableViewCellDelegate {
    func didTapOnMenuButton(with name: String) {
        switch name {
        case "AllVerbsViewController":
            let newVC = AllVerbsViewController()
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        case "FavoritesVerbsViewController":
            let newVC = FavoritesVerbsViewController()
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        case "LearningViewController":
            let newVC = LearningViewController()
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        default:
            let newVC = AllVerbsViewController()
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        }
    }
}
