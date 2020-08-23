//
//  MenuViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/9/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var buttonTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonTableView.rowHeight = 200
        buttonTableView.dataSource = self
        buttonTableView.delegate = self
        buttonTableView.separatorStyle = .none
        
        appNameLabel.backgroundColor = .clear
        appNameLabel.layer.borderWidth = 4
        appNameLabel.layer.borderColor = UIColor(named:"projectColor")?.cgColor
        
    }

}

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
        let cellID = "ButtonIDCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ButtonTableViewCell else { fatalError("Can't not find cell with \(cellID) at index \(indexPath)")
        }
        cell.delegate = self
        cell.update(with: buttonsOnMenu[indexPath.row])
        return cell
    }
    
}


extension MenuViewController: ButtonTableViewCellDelegate {
    
    func didTapOnMenuButton(with name: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: name)
        newVC.modalPresentationStyle = .fullScreen
        present(newVC, animated: true, completion: nil)
    }
}
