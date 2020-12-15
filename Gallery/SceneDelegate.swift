/*
See LICENSE folder for this sample’s licensing information.

Abstract:
This class demonstrates how to use the scene delegate to configure a scene's interface.
 It also implements basic state restoration.
*/

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // MARK: - UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            if !configure(window: window, with: userActivity) {
                Swift.debugPrint("Failed to restore from \(userActivity)")
            }
        }
        // The `window` property will automatically be loaded with the storyboard's initial view controller.
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
    
    // Utilities
    
    func configure(window: UIWindow?, with activity: NSUserActivity) -> Bool {
        var configured = false
        if activity.title == Photo.GalleryOpenDetailPath {
            if let photoID = activity.userInfo?[Photo.GalleryOpenDetailPhotoIdKey] as? String {
                // Restore the view controller with the photoID.
                if let photoDetailViewController = PhotoDetailViewController.loadFromStoryboard() {
                    photoDetailViewController.photo = Photo(name: photoID)
                    
                    if let navigationController = window?.rootViewController as? UINavigationController {
                        navigationController.pushViewController(photoDetailViewController, animated: false)
                        configured = true
                    }
                }
            }
        }
        return configured
    }
}
