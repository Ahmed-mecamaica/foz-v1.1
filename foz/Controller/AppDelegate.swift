//
//  AppDelegate.swift
//  foz
//
//  Created by Ahmed Medhat on 15/08/2021.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        initWindow()
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        Messaging.messaging().subscribe(toTopic: "MAIKA")
        Messaging.messaging().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
         let host = urlComponent?.host
         if host == "deepLinkingTest" {
             let loginvc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "login_view_controller") as? LoginVC
             window?.rootViewController = loginvc
         }
        return true
    }

}

extension AppDelegate {
    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    func initWindow() {
        let controller: UIViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        if let current = LoginResponse.current {
            AuthService.Auth.token = current.data.access_token
            controller = storyboard.instantiateViewController(identifier: "home-VC")

        } else {
            controller = storyboard.instantiateViewController(identifier: "FirstScreen")
        }
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}

//MARK:- handeling device token
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //set fcm token inside login vc whitch use in post fcm token function
        
        OtpVC.fcm_token = "\(fcmToken ?? "")"
//        print("fcm: \(OtpVC.fcm_token)")
//        print("fcm from messaging: \(fcmToken)")
    }
}

//MARK:- handeling device token
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardWhenPanGestureAround() {
        let pan = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        pan.direction = .down
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
    }
    
    @objc func dismissKeyboard(target: AnyObject) {
        view.endEditing(true)
    }
}


extension UITableViewCell {
    func hideKeyboardWhenTappedAroundCell() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(target: AnyObject) {
        self.endEditing(true)
    }
}
