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

class FavoritesVerbCell: UITableViewCell, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let verbButton = UIButton()
    let verbPast = UIButton()
    let verbPastPerfect = UIButton()
    let scrollContent = UIView()
    
    weak var delegate: FavoritesVerbCellDelegate!
    var verb: IrregularVerb?
    
    func update(with newVerb: IrregularVerb) {
        self.backgroundColor = UIColor(named: "projectColor2")
                
                //MARK: -> Set Up Scroll View
                func setUpScrollView() {
                    scrollView.delegate = self
                    scrollView.isScrollEnabled = true
        //            scrollView.showsHorizontalScrollIndicator = false
                    scrollView.contentSize = CGSize(width: 583, height: 100)
                    self.addSubview(scrollView)
                }
                
                func setUpScrollViewConstraint() {
                    self.scrollView.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                    self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                    self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                }
                
                //MARK: -> Set Up Scroll Content
                func setUpScrollContent() {
                    self.scrollView.addSubview(scrollContent)
                }
                
                func setUpScrollContentConstraint() {
                    self.scrollContent.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollContent.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                    self.scrollContent.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    self.scrollContent.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                    self.scrollContent.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                    self.scrollContent.widthAnchor.constraint(equalToConstant: 583).isActive = true
                }
                
                //MARK: -> Set Up Verb Past
                func setUpVerbPast() {
                    verbPast.setTitle(newVerb.pastSimple?.uppercased(), for: .normal)
                    verbPast.setTitleColor(UIColor(named: "projectColor"), for: .normal)
                    verbPast.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 38)
                    verbPast.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
                    self.scrollContent.addSubview(verbPast)
                }
                
                func setUpVerbPastConstraint() {
                    self.verbPast.translatesAutoresizingMaskIntoConstraints = false
                    self.verbPast.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor).isActive = true
                    self.verbPast.leadingAnchor.constraint(equalTo: self.verbButton.trailingAnchor, constant: 100).isActive = true
                }
                
                //MARK: -> Set Up Verb Button
                func setUpVerbButton() {
                    verbButton.setTitle(newVerb.infinitive?.uppercased(), for: .normal)
                    verbButton.setTitleColor(UIColor(named: "projectColor"), for: .normal)
                    verbButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 38)
                    verbButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
                    self.scrollContent.addSubview(verbButton)
                }
                
                func setUpVerbButtonConstraint() {
                    self.verbButton.translatesAutoresizingMaskIntoConstraints = false
                    self.verbButton.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor).isActive = true
                    self.verbButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
                }
                
                //MARK: -> Set Up Verb Perfect
                func setUpVerbPerfect() {
                    verbPastPerfect.setTitle(newVerb.pastParticiple?.uppercased(), for: .normal)
                    verbPastPerfect.setTitleColor(UIColor(named: "projectColor"), for: .normal)
                    verbPastPerfect.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 38)
                    verbPastPerfect.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
                    self.scrollContent.addSubview(verbPastPerfect)
                }
                
                func setUpVerbPerfectConstraint() {
                    self.verbPastPerfect.translatesAutoresizingMaskIntoConstraints = false
                    self.verbPastPerfect.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor).isActive = true
                    self.verbPastPerfect.leadingAnchor.constraint(equalTo: self.verbPast.trailingAnchor, constant: 100).isActive = true
                }

                setUpScrollView()
                setUpScrollViewConstraint()
                
                setUpScrollContent()
                setUpScrollContentConstraint()
                
                setUpVerbButton()
                setUpVerbButtonConstraint()
                
                setUpVerbPast()
                setUpVerbPastConstraint()
                
                setUpVerbPerfect()
                setUpVerbPerfectConstraint()
        verb = newVerb
    }
    
    @objc func tapButton(_ sender: Any) {
        delegate?.didTapOnVerbButton(with: verb)
    }

}
