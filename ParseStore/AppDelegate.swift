//
//  AppDelegate.swift
//  ParseStore
//
//  Created by Zhitao Fan on 5/7/17.
//  Copyright © 2017 Zhitao Fan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var window: UIWindow?

    // MARK: - life cycles

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = ParseClientConfiguration(block: {(configuration: ParseMutableClientConfiguration) -> Void in
                configuration.server = "http://localhost:1337/parse"
                configuration.applicationId = "APP_ID0"
                configuration.clientKey = "MASTER_KEY0"
            })
        Parse.initialize(with: configuration)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        let controller0 = UINavigationController(rootViewController: PFProductsTableViewController(style: .plain))
        controller0.navigationBar.isHidden = true
        let controller1 = PFProductsViewController()
        let controller2 = PFProductsViewController()
        let controller3 = UINavigationController(rootViewController: ShoppingCartTableViewController(style: .plain))
        let controller4 = UINavigationController(rootViewController: OrderHistoryTableViewController())
        controller4.navigationBar.isHidden = true
        tabBarController.viewControllers = [controller0, controller1, controller2, controller3, controller4]
        controller0.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        controller1.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        controller2.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 2)
        controller3.tabBarItem = UITabBarItem(title: "Cart", image: nil, tag: 3)
        controller4.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)

        window?.rootViewController = tabBarController
        
        return true
    }
    
    // MARK: - PFLogInViewControllerDelegate
    
    public func log(_ logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        return true;
    }
    
    public func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        logInController.dismiss(animated: true, completion: nil)
    }
    
    public func log(_ logInController: PFLogInViewController, didFailToLogInWithError error: Error?) {
        print("Error: \(String(describing: error?.localizedDescription))")
        let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        controller.addAction(defaultAction)
        logInController.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - PFSignUpControllerDelegate
    public func signUpViewController(_ signUpController: PFSignUpViewController, shouldBeginSignUp info: [String : String]) -> Bool {
        return true
    }
    
    public func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        signUpController.dismiss(animated: true, completion: {() -> Void in
            var topViewController = self.window?.rootViewController
            while ((topViewController?.presentedViewController) != nil) {
                topViewController = topViewController?.presentedViewController
            }
            if (topViewController is PFLogInViewController) {
                topViewController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    public func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: Error?) {
        print("Error: \(String(describing: error?.localizedDescription))")
        let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        controller.addAction(defaultAction)
        signUpController.present(controller, animated: true, completion: nil)
    }
}

