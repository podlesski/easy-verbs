//
//  UniqueButton.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/9/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import Foundation

class UniqueButton {
    let name: String
    let side: Int
    let id: String
    
    init(name: String, side: Int, id: String) {
        self.name = name
        self.side = side
        self.id = id
    }
}

let buttonsOnMenu = [UniqueButton(name: "VOCAB LUARY", side: 1, id: "AllVerbsViewController"), UniqueButton(name: "FAVO RITES", side: 2, id: "FavoritesVerbsViewController"), UniqueButton(name: "TRAI NING", side: 1, id: "LearningViewController")]

