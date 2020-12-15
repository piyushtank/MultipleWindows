# Supporting Multiple Windows on iPad

Support side-by-side instances of your interface and create a new window with drag-and-drop simplicity.

## Overview

This sample shows how to create multiple windows that give users the ability to create separate parts of your application with similar or varying content. Windows are managed by a scene or [`UISceneSession`](https://developer.apple.com/documentation/uikit/uiscenesession) class. Your application uses [`UISceneDelegate`](https://developer.apple.com/documentation/uikit/uiscenedelegate) and [`UISceneConfiguration`]() to manage the life cycle of a window. Scenes have their own dedicated lifecycle that are managed separate from [`UIApplication`](https://developer.apple.com/documentation/uikit/uiapplication).

When you adopt a multi-window architecture, the [`UIApplicationDelegate`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate) class that manages your application now manages newly created scenes. Then, `UISceneDelegate` replaces the code in the delegate functions of `UIApplicationDelegate`.

UIKit provides a subclass of `UISceneDelegate` called [`UIWindowSceneDelegate`](https://developer.apple.com/documentation/uikit/uiwindowscenedelegate) designed specifically to help manage your windows. When adopting the multi-window architecture in an existing application running on iOS 12 or earlier, you will move more responsibility from `UIApplicationDelegate` to `UIWindowSceneDelegate`.

For more information on multiple windows in an iPadOS app, refer to [Human Interface Guidelines for iOS](https://developer.apple.com/design/human-interface-guidelines/ios/system-capabilities/multiple-windows/).

- Note: This sample code project was discussed and demonstrated at WWDC 2019 session 212: [Introducing Multiple Windows on iPad](https://developer.apple.com/videos/play/wwdc2019/212).

## Add Multiple Scene Support

To support multiple windows, the app's `Info.plist` requires a manifest or [`UIApplicationSceneManifest`](https://developer.apple.com/documentation/bundleresources/information_property_list/uiapplicationscenemanifest), which contains the information about the app's scene-based life-cycle support. The presence of this key indicates that the app supports scenes and does not use an app delegate object to manage transitions to and from the foreground or background. Include the key [`UIApplicationSupportsMultipleScenes`](https://developer.apple.com/documentation/bundleresources/information_property_list/uiapplicationscenemanifest/uiapplicationsupportsmultiplescenes), with its boolean value set to true, which indicates that the app support two or more scenes simultaneously.

## Add a Scene Delegate

This sample provides a `UIWindowScene` subclass called `SceneDelegate` to manage the app's primary window scene. The [`scene(_:willConnectTo:options:)`](https://developer.apple.com/documentation/uikit/uiscenedelegate/3197914-scene) delegate function sets up the window and content.

``` swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
        if !configure(window: window, with: userActivity) {
            Swift.debugPrint("Failed to restore from \(userActivity)")
        }
    }
    // The `window` property will automatically be loaded with the storyboard's initial view controller.
}
```

By using [`UISceneConfigurations`](https://developer.apple.com/documentation/bundleresources/information_property_list/uiapplicationscenemanifest/uisceneconfigurations) key in the `Info.plist` scene manifest, the sample's window for this scene is automatically configured and its root view controller is loaded from the storyboard.

## Restore a Scene

When it's time to restore a scene, iOS will call your delegate `scene(_:willConnectTo:options:)`. The sample app restores the scene to its previous state through the use of [`NSUserActivity`](https://developer.apple.com/documentation/foundation/nsuseractivity).

``` swift
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
```

## Create Multiple Windows

This sample creates a separate window only when the user drags an image from the collection view to the left or right side of the iPad screen. The sample creates a new window by implementing `UICollectionViewDragDelegate` function [`collectionView(_:itemsForBeginning:at:)`](https://developer.apple.com/documentation/uikit/uicollectionviewdragdelegate/2897389-collectionview) and providing a [`UIDragItem`](https://developer.apple.com/documentation/uikit/uidragitem) with an associated [`NSItemProvider`](https://developer.apple.com/documentation/foundation/nsitemprovider). Then, the sample passes the photo data to the new window scene with a registered `NSUserActivity`.

``` swift
func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    var dragItems = [UIDragItem]()
    let selectedPhoto = photo(at: indexPath)
    if let imageToDrag = UIImage(named: selectedPhoto.name) {
        let userActivity = selectedPhoto.openDetailUserActivity
        let itemProvider = NSItemProvider(object: imageToDrag)
        itemProvider.registerObject(userActivity, visibility: .all)

        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = selectedPhoto
        dragItems.append(dragItem)
    }
    return dragItems
}
```


