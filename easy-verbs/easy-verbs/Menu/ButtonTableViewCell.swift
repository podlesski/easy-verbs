//
//  ButtonTableViewCell.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/9/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    
    func didTapOnMenuButton(with name: String)
}

class ButtonTableViewCell: UITableViewCell {
    
    let button = UIButton()
    let rightArrow = UIImageView()
    let leftArrow = UIImageView()
    
    weak var delegate: ButtonTableViewCellDelegate!
    var nameForSegue = String()
    
    func update(with newButton: UniqueButton) {
        self.backgroundColor = UIColor(named: "projectColor2")
        
        //MARK: -> Set Up Button
        func setUpButton() {
            button.setTitle(newButton.name, for: .normal)
            button.setTitleColor(UIColor(named: "projectColor"), for: .normal)
            button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 38)
            button.contentHorizontalAlignment = .right
            button.contentVerticalAlignment = .bottom
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.numberOfLines = 2
            button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
            self.addSubview(button)
        }
        
        func setUpButtonConstraint() {
            self.button.translatesAutoresizingMaskIntoConstraints = false
            self.button.widthAnchor.constraint(equalToConstant: 140).isActive = true
            self.button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        //MARK: -> Set Up Right Arrow
        func setUpRightArrow() {
            self.rightArrow.image = UIImage(named: "rightArrow")
            self.rightArrow.contentMode = .scaleAspectFit
            self.addSubview(rightArrow)
        }
        
        func setUpRightArrowConstraint() {
            self.rightArrow.translatesAutoresizingMaskIntoConstraints = false
            self.rightArrow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
            self.rightArrow.widthAnchor.constraint(equalToConstant: 60).isActive = true
            self.rightArrow.heightAnchor.constraint(equalToConstant: 45).isActive = true
            self.rightArrow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        }
        
        //MARK: -> Set Up Left Arrow
        func setUpLeftArrow() {
            self.leftArrow.image = UIImage(named: "leftArrow")
            self.leftArrow.contentMode = .scaleAspectFit
            self.addSubview(leftArrow)
        }
        
        func setUpLeftArrowConstraint() {
            self.leftArrow.translatesAutoresizingMaskIntoConstraints = false
            self.leftArrow.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
            self.leftArrow.widthAnchor.constraint(equalToConstant: 60).isActive = true
            self.leftArrow.heightAnchor.constraint(equalToConstant: 45).isActive = true
            self.leftArrow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        }
        
        setUpButton()
        setUpButtonConstraint()
        
        setUpRightArrow()
        setUpRightArrowConstraint()
        
        setUpLeftArrow()
        setUpLeftArrowConstraint()
        
        //MARK: -> Cell Logic
        if newButton.side == 2 {
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
            button.contentHorizontalAlignment = .left
            rightArrow.isHidden = true
        } else {
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
            leftArrow.isHidden = true
        }
        self.selectionStyle = .none
        nameForSegue = newButton.id
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func tapOnButton(_ sender: Any) {
        guard delegate != nil else { return }
        self.delegate.didTapOnMenuButton(with: nameForSegue)
    }
    

}
