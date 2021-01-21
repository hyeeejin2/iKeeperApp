//
//  SceneDelegate.swift
//  ikeeperApp
//
//  Created by 김혜진 on 2020/11/03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
//        let tabBarController = UITabBarController()
//        
//        let homeViewController = HomeViewController()
//        let informationViewController = InformationViewController()
//        let calendarViewController = CalendarViewController()
//        let publicMoneyViewController = PublicMoneyViewController()
//        let mypageViewController = MypageViewController()
//        
//        homeViewController.tabBarItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), tag: 0)
//        informationViewController.tabBarItem = UITabBarItem(title: "information", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)
//        calendarViewController.tabBarItem = UITabBarItem(title: "calendar", image: UIImage(systemName: "calendar"), tag: 2)
//        publicMoneyViewController.tabBarItem = UITabBarItem(title: "public money", image: UIImage(systemName: "dollarsign.circle"), tag: 3)
//        mypageViewController.tabBarItem = UITabBarItem(title: "mypage", image: UIImage(systemName: "person.circle"), tag: 4)
//        tabBarController.viewControllers = [homeViewController, informationViewController, calendarViewController, publicMoneyViewController, mypageViewController]
//        
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//        window?.rootViewController = tabBarController
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

