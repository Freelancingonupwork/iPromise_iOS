//
//  AppDelegate.swift
//  iPromise
//
//  Created by Apple on 13/03/23.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseMessaging
import Firebase
import FirebaseDynamicLinks
import SwiftyJSON
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - variable
    var window:UIWindow?
    var navigationVC = UINavigationController()
    let gcmMessageIDKey = "gcm.message_id"
    
    //MARK: - app delegate lie cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        registerForRemoteNotifications()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        var vc = UIViewController()
        vc = SplashVC(nibName: "SplashVC", bundle: nil)
    
        navigationVC = UINavigationController(rootViewController: vc)
        IQKeyboardManager.shared.enable = true
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Log.info("Deep link received \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if (dynamicLink.url != nil) {
                showDeeopLinkAler(dynamicUrl: dynamicLink.url!.absoluteString)
            }
        }
        else{
            showDeeopLinkAler(dynamicUrl: String(format: "OpenURL:\n%@", url.absoluteString))
            return true
        }
        
        return false
    }

    
    func showDeeopLinkAler(dynamicUrl : String) {
        let encodedLink = dynamicUrl
        let decondedUrl = encodedLink.removingPercentEncoding
        let items  = decondedUrl?.replacingOccurrences(of: "\(mainUrl)?", with: "")
        let itemsOFPromise = items?.components(separatedBy: "&")
        for item in itemsOFPromise! {
            let pair = item.components(separatedBy: "=")
            if pair.first == "phone"{
                promiseByDeepLink.phoneNumber = "+\(pair.last ?? "")"
            }
            else if pair.first == "promiseId" {
                promiseByDeepLink.promiseId = pair.last ?? ""
            }
            else{
                promiseByDeepLink.isMaker = ((pair.last ?? "") == "1") ? true : false
            }
        }
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        Log.info("continue userActivity: NSUserActivity - called")
        return true
    }

    // MARK: - Push Notifiction
    
    func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self     
        center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        })
        
    }

    internal func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.info("Notification registation failed" + error.localizedDescription)
    }
    

    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            Log.info("Message ID: \(messageID)")
        }
        print(userInfo)
      }
      func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            Log.info("Message ID: \(messageID)")
        }
        
        completionHandler(.newData)

      }

      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          Log.info("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
      }
    
}


@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
      if Utils.getUserDetail(.id) != ""{
          if self.window?.rootViewController?.topVC is NotificationsVC {
              completionHandler([])
          }
          else {
              completionHandler([.alert, .badge, .sound])
          }
      }
      else{
          completionHandler([])
      }
  }

    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        let vcs = UIApplication.shared.keyWindow?.rootViewController?.navigationController?.viewControllers
        if ((vcs?.contains(where: { $0.isKind(of: HomeVC.self)})) != nil){
            Log.info("have home")
        }
        let content = JSON(response.notification.request.content.userInfo)
        receivedNotification = content
        completionHandler()
    }
    
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Log.info("Firebase registration token: \(String(describing: fcmToken))")
        strFCMToken = fcmToken ?? ""
        let dataDict: [String: String] = ["token": fcmToken ?? "" ]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),object: nil,userInfo: dataDict)
  }
}
