//
//  AppDelegate.swift
//  Flash Chat
//
//  The App Delegate listens for events from the system. 
//  It recieves application level messages like did the app finish launching or did it terminate etc. 
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: Initialise and Configure your Firebase here:
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }
    func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var quickActionHandled = false
        let type = shortcutItem.localizedTitle
        if let shortcutType = Shortcut.init(rawValue: type){
            switch shortcutType {
            case .login:
                quickActionHandled = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as UIViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(viewController, animated: false);
            case .register:
                quickActionHandled = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "registrationVC")
                let rootViewCotroller = self.window?.rootViewController as! UINavigationController
                rootViewCotroller.pushViewController(viewController, animated: false)
            }
        }
        return quickActionHandled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

enum Shortcut: String {
    case login = "Login"
    case register = "Register"
}

