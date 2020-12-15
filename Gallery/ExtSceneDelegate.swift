//
//  ExtSceneDelegate.swift
//  Gallery
//
//  Created by Piyush Tank on 12/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//



import UIKit

class ExtSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // MARK: - UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
    
    // Utilities
    
    func configure(window: UIWindow?, with activity: NSUserActivity) -> Bool {
        return true
    }
}
