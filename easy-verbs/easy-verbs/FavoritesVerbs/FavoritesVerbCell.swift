//
//  FavoritesVerbCell.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 3/3/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit

protocol FavoritesVerbCellDelegate: AnyObject {
    
    func didTapOnVerbButton(with verb: IrregularVerb?)
}

class FavoritesVerbCell: UITableViewCell {
    
    @IBOutlet weak var verbButton: UIButton!
    @IBOutlet weak var verbPast: UIButton!
    @IBOutlet weak var verbPastPerfect: UIButton!
    
    weak var delegate: FavoritesVerbCellDelegate!
    var verb: IrregularVerb?
    
    func update(with newVerb: IrregularVerb) {
        verbButton.setTitle(newVerb.infinitive?.uppercased(), for: .normal)
        verbPast.setTitle(newVerb.pastSimple?.uppercased(), for: .normal)
        verbPastPerfect.setTitle(newVerb.pastParticiple?.uppercased(), for: .normal)
        verb = newVerb
    }
    
    @IBAction func tapButton(_ sender: Any) {
        delegate?.didTapOnVerbButton(with: verb)
    }

}
