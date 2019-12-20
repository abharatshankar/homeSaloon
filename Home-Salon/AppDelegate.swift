//
//  AppDelegate.swift
//  Home-Salon
//
//  Created by volivesolutions on 30/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKCoreKit
import MOLH


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
      
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyCh-YbEG2kBFdTYIqGu0ONA0LvVPb9FBVE")
        
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                
                if (granted)
                {
                    DispatchQueue.main.sync(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }else{
                    //Do stuff if unsuccessful...
                }
            }
        }
        
        
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            print("no internet")
            //showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
        
        loginCall()
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.
        return true
    }
    
    
    
    func loginCall(){
        
        let type = UserDefaults.standard.object(forKey: "type2") as? String ?? ""
        
        if type == "user"
        {
            let userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
            
            if userName.count > 0
            {
           
            let stroryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let HomeviewController: UIViewController = stroryBoard.instantiateViewController(withIdentifier:"UserHomeViewController")
            window?.rootViewController = HomeviewController
            window?.makeKeyAndVisible()
           
            }
            
        }
        else if type == "provider"
        {
            
            let userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
           // let verifyOrNot = UserDefaults.standard.set("false" as Any, forKey: "bool") as? String ?? ""
            
            if userName.count > 0 
            {
                
            let stroryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let HomeviewController: UIViewController = stroryBoard.instantiateViewController(withIdentifier:"SPHomeVC1")
            window?.rootViewController = HomeviewController
            window?.makeKeyAndVisible()
            }
        }
       
    }
    
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
         UIApplication.shared.applicationIconBadgeNumber = 0
        
         AppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceToken is:",deviceTokenString)
        DEVICE_TOKEN = deviceTokenString
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
    }
    
    

}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    @available(iOS 10.0, *)
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        let userInfo = notification.request.content.userInfo as! Dictionary <String,Any>
        let aps = userInfo["aps"] as! Dictionary<String,Any>
        print("will present data:",userInfo)
        
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue)|UInt8(UNNotificationPresentationOptions.sound.rawValue))))
                 let info = aps["info"] as! Dictionary<String,Any>
        let dicNotificationData = info as NSDictionary
        if let type = dicNotificationData["type"] as? String
        {
            print(type)
            
            if type == "order_accepted"
            {
                let invoiceNumber = dicNotificationData["invoice_id"] as? String
                let orderId = dicNotificationData["order_id"] as? String
                
                    let userRequests = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceDetailsViewController") as! UserInvoiceDetailsViewController
                
                  userRequests.checkString = "Side"
                  userRequests.orderId = orderId ?? ""
                  userRequests.invoiceId = invoiceNumber ?? ""
                
                    let nav = UINavigationController.init(rootViewController: userRequests)
                    
                    self.window?.rootViewController = nav
                    self.window?.makeKeyAndVisible()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
                
            }
            
            else if type == "request"
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "providerRequest"), object: nil)
            }
                
            else if type == "order_start"
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "order_start"), object: nil)
            }
            
            else if type == "order_complete"
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "order_complete"), object: nil)
            }
            else if type == "order_payment"
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "order_payment"), object: nil)
            }
            
            else if type == "order_cancel"
            {
                 let type = UserDefaults.standard.object(forKey: "type2") as? String ?? ""
                 let userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
                
                if type == "user" && userName.count > 0
                {
                
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userCancel"), object: nil)
                    
                }
                if type == "provider" && userName.count > 0
                {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProviderCancel"), object: nil)
                    
                }
            }
        
            
        }
        
       
       
    }
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        
        let userInfo = response.notification.request.content.userInfo
        
        let aps = userInfo["aps"] as! Dictionary<String,Any>
        let badge = aps["badge"] as! Int
        UIApplication.shared.applicationIconBadgeNumber = badge
        
        print(userInfo)
        
       
        let info = aps["info"] as! Dictionary<String,Any>
        let dicNotificationData = info as NSDictionary
        if let type = dicNotificationData["type"] as? String
        {
            print(type)
            
            // user notification when provider accept request
            
            if type == "order_accepted"
            {
                let invoiceNumber = dicNotificationData["invoice_id"] as? String
                let orderId = dicNotificationData["order_id"] as? String
                
            let userRequests = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceDetailsViewController") as! UserInvoiceDetailsViewController
                userRequests.checkString = "Side"
                userRequests.orderId = orderId ?? ""
                userRequests.invoiceId = invoiceNumber ?? ""
                
            let nav = UINavigationController.init(rootViewController: userRequests)
            
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
            }
            
            // provider notification when user send order request
            
            else if type == "request"
            {
                let provider = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
                let nav = UINavigationController.init(rootViewController: provider)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "providerRequest"), object: nil)
            }
            
                // when work start user get notification
            else if type == "order_start"
            {
                let user = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
                user.checkString = "Side"
                let nav = UINavigationController.init(rootViewController: user)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()


            }
                /// when order completed user get notification
            else if type == "order_complete"
            {
                let user = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserOrdersViewController") as! UserOrdersViewController
                user.checkString = ""
                let nav = UINavigationController.init(rootViewController: user)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                
                
            }
            //  payment notification to service provider
            else if type == "order_payment"
            {
                let user = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingVC") as! PendingVC
                user.checkStr1 = ""
                let nav = UINavigationController.init(rootViewController: user)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                
                
            }

            else if type == "order_cancel"
            {
                let type = UserDefaults.standard.object(forKey: "type2") as? String ?? ""
                let userName = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
                
                if type == "user" && userName.count > 0
                {
                    let user = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
                    user.checkString = "Side"
                    let nav = UINavigationController.init(rootViewController: user)
                    self.window?.rootViewController = nav
                    self.window?.makeKeyAndVisible()

                    
                }
                if type == "provider" && userName.count > 0
                {
                    let reject = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                    reject.checkStr = "req"
                    reject.checkIntValue = "5"
                    let nav = UINavigationController.init(rootViewController: reject)
                    self.window?.rootViewController = nav
                    self.window?.makeKeyAndVisible()
                   
                    
                }
            }
            
            
        }
        
    }
    
    
//    will present data: ["aps": {
//    alert = "Request accepted\\nYour request has been accepted now,the provider will arrive at you within two hours";
//    badge = 1;
//    info =     {
//    "invoice_id" = HS5DE24FA25C05D7;
//    "ios_msg" = "Request accepted\\nYour request has been accepted now,the provider will arrive at you within two hours";
//    "notification_message_en" = "Your request has been accepted now,the provider will arrive at you within two hours";
//    "notification_title_en" = "Request accepted\\nYour request has been accepted now,the provider will arrive at you within two hours";
//    "order_id" = 357;
//    type = "order_accepted";
//    };
//    sound = default;
//    }]

    
    
//    [AnyHashable("aps"): {
//    alert = "Order accepted\\nDear user Your order has been accepted now";
//    badge = 0;
//    info =     {
//    "ios_msg" = "Order accepted\\nDear user Your order has been accepted now";
//    "notification_message_en" = "Dear user Your order has been accepted now";
//    "notification_title_en" = "Order accepted\\nDear user Your order has been accepted now";
//    "order_id" = 98;
//    "order_status" = 0;
//    "owner_id" = 83;
//    type = "order_accepted";
//    unread = 0;
//    };
//    sound = default;
//    }]
    
}
