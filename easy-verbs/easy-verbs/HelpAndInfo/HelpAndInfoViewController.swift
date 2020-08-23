//
//  HelpAndInfoViewController.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 3/8/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import Crashlytics


class HelpAndInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

}
