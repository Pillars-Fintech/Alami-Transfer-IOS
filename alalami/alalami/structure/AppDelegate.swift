//
//  AppDelegate.swift
//  alalami
//
//  Created by Zaid Khaled on 8/31/20.
//  Copyright © 2020 technzone. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
import IQKeyboardManagerSwift
import BRYXBanner
import Firebase
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import netfox



open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
    open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return ServerTrustPolicy.disableEvaluation
    }
}
//
//var AFManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))


var AFManager = SessionManager()

//var AFManager = SessionManager()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable,MessagingDelegate ,UNUserNotificationCenterDelegate {
    
    

    
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        NFX.sharedInstance().start()
        MOLH.shared.activate(true)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        
        GMSServices.provideAPIKey("\(Constants.GOOGLE_API_KEY)")
        GMSPlacesClient.provideAPIKey("\(Constants.GOOGLE_API_KEY)")
        
        //i am update
        let configuration = URLSessionConfiguration.default
        
        
        configuration.timeoutIntervalForRequest = -1 // seconds
        configuration.timeoutIntervalForResource = -1 //seconds
        
        
        AFManager = Alamofire.SessionManager(configuration: configuration)
        
        
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            MOLH.setLanguageTo("ar")
            MOLHLanguage.setAppleLAnguageTo("ar")
            
        }else {
            MOLH.setLanguageTo("en")
            MOLHLanguage.setAppleLAnguageTo("en")

        }
        
        // firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        
//        network interceptor
         #if DEBUG
//         NFX.sharedInstance().start()
         #endif
        
        return true
    }
    
    func reset() {
        let check = UserDefaults.standard.value(forKey: Constants.DEFAULT_KEYS.DID_SEE_INTRO) as? Bool ?? false
        if (check) {
            self.openHome()
        }else {
            self.openLanguage()
        }
    }
    
    
    func openSplash() {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: Constants.STORYBOARDS.authentication, bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "SplashVC")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
    }
    
    
    func openHome() {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: Constants.STORYBOARDS.main, bundle: nil)
        let initialViewControlleripad : UINavigationController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
    }
    
    func openLanguage() {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: Constants.STORYBOARDS.authentication, bundle: nil)
        let initialViewControlleripad : LanguageVC = mainStoryboardIpad.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        updateNotificationCount()
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let apiManager = ApiManager()
        let keychain = KeychainSwift()
        let accessToken = keychain.get("alami_xtokxenx_biometry") ?? ""
        apiManager.updateDeviceInfo(token: accessToken, regId: fcmToken ?? "not_available") { (response) in
            
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        
        if(application.applicationState == .active) {
            print("user tapped the notification bar when the app is in foreground")
            let type = response.notification.request.content.userInfo[Constants.NOT_KEY_TYPE] as? String ?? "0"
            let data = response.notification.request.content.userInfo[Constants.NOT_KEY_VALUE] as? String ?? "0"
            App.shared.notificationType = type
            App.shared.notificationValue = data
            self.openSplash()
        }
        
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
            let type = response.notification.request.content.userInfo[Constants.NOT_KEY_TYPE] as? String ?? "0"
            let data = response.notification.request.content.userInfo[Constants.NOT_KEY_VALUE] as? String ?? "0"
            
            App.shared.notificationType = type
            App.shared.notificationValue = data
            self.openSplash()
        }
        
        /* Change root view controller to a specific viewcontroller */
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // let vc = storyboard.instantiateViewController(withIdentifier: "ViewControllerStoryboardID") as? ViewController
        // self.window?.rootViewController = vc
        updateNotificationCount()
        
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //  LabasNotificationsManager.shared.addNotification(userInfo: userInfo)
        
        
        var title = ""
        var body = ""
        var type = ""
        var data = ""
        
        if MOLHLanguage.isRTLLanguage() {
            title = userInfo[Constants.NOT_KEY_TITLE_AR] as? String ?? ""
            body = userInfo[Constants.NOT_KEY_BODY_AR] as? String ?? ""
        } else {
            title = userInfo[Constants.NOT_KEY_TITLE_EN] as? String ?? ""
            body = userInfo[Constants.NOT_KEY_BODY_EN] as? String ?? ""
        }
        type = userInfo[Constants.NOT_KEY_TYPE] as? String ?? "0"
        data = userInfo[Constants.NOT_KEY_VALUE] as? String ?? "0"
        
        
        App.shared.notificationType = type
        App.shared.notificationValue = data
        
        scheduleNotifications(title: title , message: body, type : type, itemId: data)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        var title = ""
        var body = ""
        var type = ""
        var data = ""
        
        let _ : [AnyHashable: Any] = userInfo["aps"] as? [AnyHashable : Any] ?? [AnyHashable : Any]()
        
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            title = userInfo[Constants.NOT_KEY_TITLE_AR] as? String ?? ""
            body = userInfo[Constants.NOT_KEY_BODY_AR] as? String ?? ""
        } else {
            title = userInfo[Constants.NOT_KEY_TITLE_EN] as? String ?? ""
            body = userInfo[Constants.NOT_KEY_BODY_EN] as? String ?? ""
        }
        
        type = userInfo[Constants.NOT_KEY_TYPE] as? String ?? "0"
        data = userInfo[Constants.NOT_KEY_VALUE] as? String ?? ""
        
        App.shared.notificationType = type
        App.shared.notificationValue = data
        
        let state: UIApplication.State = UIApplication.shared.applicationState // or use  let state =  UIApplication.sharedApplication().applicationState
        
        if state == .background {
            scheduleNotifications(title: title , message: body,type: type,itemId: "")
        } else if state == .active {
            //do login when app is active
            updateNotificationCount()
        }else {
            updateNotificationCount()
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
//    func restApp(){
//        let dir = MOLH
//    }
    
    func showBanner(title:String, message:String,style: UIColor, type : String) {
        let banner = Banner(title: title, subtitle: message, image: nil, backgroundColor: style)
        banner.dismissesOnTap = true
        banner.textColor = UIColor.white
        banner.titleLabel.font = UIFont(name: getFontName(), size: 16)
        banner.detailLabel.font = UIFont(name: getFontName(), size: 14)
        banner.show(duration: 2.0)
        
        banner.didTapBlock = {
            
        }
    }
    
    func getFontName() -> String {
        if (MOLHLanguage.currentAppleLanguage() == "ar") {
            return Constants.ARABIC_MEDIUM
        }else {
            return Constants.ENGLISH_MEDIUM
        }
    }
    
    
    func updateNotificationCount() {
        let defaults = UserDefaults.standard
        var notificationCount : Int = defaults.value(forKey: Constants.NOTIFICATION_COUNT) as? Int ?? 0
        notificationCount = notificationCount + 1
        defaults.setValue(notificationCount, forKey: Constants.NOTIFICATION_COUNT)
        NotificationCenter.default.post(name: Notification.Name("notificationsCountShouldRefresh"), object: nil)
    }
    
    
    func scheduleNotifications(title : String, message : String, type : String, itemId : String) {
        
        self.updateNotificationCount()
        
        let requestIdentifier = "Notification"
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            
            content.badge = 1
            content.title = title
            content.subtitle = "appname".localized
            content.body = message
            content.categoryIdentifier = "actionCategory"
            //  content.sound = UNNotificationSound.default
            content.sound =  .default
            
            //  self.updateChat()
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3.0, repeats: false)
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "not localized")
                }
                print("Notification Register Success")
            }
            
        } else {
            // Fallback on earlier versions
            // Fallback on earlier versions

            let content = UILocalNotification()
            
            content.alertTitle = title
            content.alertBody = message
            content.category = ""
            
        }
    }
}
