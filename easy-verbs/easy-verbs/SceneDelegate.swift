//
//  SceneDelegate.swift
//  easy-verbs
//
//  Created by Artemy Podlessky on 2/6/20.
//  Copyright © 2020 Artemy Podlessky. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    
    func showAuthViewController() {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let newvc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        newvc.modalPresentationStyle = .fullScreen
      self.window?.rootViewController?.present(newvc, animated: true, completion: nil)
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if Auth.auth().currentUser != nil {
            showAuthViewController()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

