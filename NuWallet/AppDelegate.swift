//
//  AppDelegate.swift
//  CryptoWallet
//
//  Created by SamLin on 2022/3/10.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkVerison()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        BN.getMember { statusCode, dataObj, err in
//        }
        checkNotification() 
        
    }
    
    func checkNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { setting in
                DispatchQueue.main.async {
                    if setting.authorizationStatus == .authorized {
                        notificationStatus.value = NotificationStatusType.authorized
                    }else if setting.authorizationStatus == .denied {
                        notificationStatus.value = NotificationStatusType.denied
                    }else if setting.authorizationStatus == .notDetermined {

                    }
                }
            }
        }
    }
    
    func checkVerison() {
//        let localVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=com.adopt0704") else {return}
        var requset = URLRequest(url: url)
        requset.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: requset) { data, response, error in
            guard let data = data, let response = response, error == nil else {return}
            do {
                let dataObj = try JSONDecoder().decode(AppleData.self, from: data)
                guard let results = dataObj.results else {return}
                if results.count > 0 {
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    // 使用者點選推播時觸發
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
        let content = response.notification.request.content
        print(content.userInfo)
        completionHandler()
    }
        
    // 讓 App 在前景也能顯示推播
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner])
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDic: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDic)
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
    
}
