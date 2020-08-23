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
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    
    weak var delegate: ButtonTableViewCellDelegate!
    var nameForSegue = String()
    
    @IBOutlet weak var constraintForButton: NSLayoutConstraint!
    
    func update(with newButton: UniqueButton) {
        if newButton.side == 2 {
            constraintForButton.priority = UILayoutPriority(rawValue: 750)
            button.contentHorizontalAlignment = .left
            rightArrow.isHidden = true
        } else {
            leftArrow.isHidden = true
        }
        button.setTitle(newButton.name, for: .normal)
        self.selectionStyle = .none
        nameForSegue = newButton.id
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func tapOnButton(_ sender: Any) {
        guard delegate != nil else { return }
        self.delegate.didTapOnMenuButton(with: nameForSegue)
    }
    

}
