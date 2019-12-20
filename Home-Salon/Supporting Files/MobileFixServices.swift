//
//  MobileFixServices.swift
//  Saleem
//
//  Created by Suman Guntuka on 16/03/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
//import Alamofire
//import SCLAlertView
import AVFoundation
import MOLH

class MobileFixServices: NSObject {
    
    static let sharedInstance = MobileFixServices()
    
//    //signUp getperamters
//    var _name: String!
//    var _email: String!
//    var _mobileNumber: String!
//    var _message: String!
//
//    var errMessage: String!
    let imageV = UIImageView()
  
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    func loader(view: UIView) -> () {
    
    DispatchQueue.main.async {
    self.indicator.frame = CGRect(x: 0,y: 0,width: 75,height: 75)
    self.indicator.layer.cornerRadius = 8
    self.indicator.center = view.center
    self.indicator.color = #colorLiteral(red: 0.631372549, green: 0.5647058824, blue: 0.5058823529, alpha: 1)
    view.addSubview(self.indicator)
    self.indicator.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    self.indicator.bringSubviewToFront(view)
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    self.indicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    }
    }
    
    func dissMissLoader()  {
    
    indicator.stopAnimating()
    imageV.removeFromSuperview()
    UIApplication.shared.endIgnoringInteractionEvents()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func noInternetConnectionlabel (inViewCtrl:UIView) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .transitionCurlUp, animations: {
    
    let lblNew = UILabel()
    lblNew.frame = CGRect(x: 0, y: 0, width: inViewCtrl.frame.size.width, height: 50)
    lblNew.backgroundColor = UIColor.gray
    lblNew.textAlignment = .center
    lblNew.text = "No Internet Connection"
    lblNew.textColor = UIColor.white
    inViewCtrl.addSubview(lblNew)
    lblNew.font=UIFont.systemFont(ofSize: 18)
    lblNew.alpha = 0.5
    lblNew.transform = .identity
    }, completion: nil)
    }
    
    
    //validate email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
  
}
    
    
extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
}


extension UIViewController {
//
//    func showToast(message : String) {
//
//
//        let appearance = SCLAlertView.SCLAppearance(
//
//            showCircularIcon: true
//
//        )
//        let alertView = SCLAlertView(appearance: appearance)
//       // var alertViewIcon = UIImage(named: "correct") //Replace the IconImage text with the image name Logo
//
//        //alertView.showInfo(languageChangeString(a_str: "Alert")!, subTitle: message ,closeButtonTitle:languageChangeString(a_str: "Done"), circleIconImage: alertViewIcon)
//
//        let timer = SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 2.0, timeoutAction: {})
//
//        alertView.showTitle("Success", subTitle: message, timeout: timer, completeText: "OK", style: .success)
//
//    }
//
//
//    func showAlert(message : String) {
//
//
//        let appearance = SCLAlertView.SCLAppearance(
//
//            showCircularIcon: true
//
//        )
//        let alertView = SCLAlertView(appearance: appearance)
//        let alertViewIcon = UIImage(named: "") //Replace the IconImage text with the image name Logo
//
//        alertView.showInfo("Alert", subTitle: message ,closeButtonTitle:"Done", circleIconImage: alertViewIcon)
//
//
//
//    }
//
    
    //MARK:LANGUAGE CHANGE STRING
    func languageChangeString(a_str: String) -> String?{
        
        var path: Bundle?
        var selectedLanguage:String = String()
        
        selectedLanguage = UserDefaults.standard.string(forKey: "currentLanguage") as? String ?? ""
        //let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        print(selectedLanguage)
        
        if selectedLanguage == ENGLISH_LANGUAGE {
            
            if let aType = Bundle.main.path(forResource: "en", ofType: "lproj") {
                path = Bundle(path: aType)!
            }
        }
        else if selectedLanguage == ARABIC_LANGUAGE {
            if let aType = Bundle.main.path(forResource: "ar", ofType: "lproj") {
                path = Bundle(path: aType)!
            }
        }
        else {
            if let aType = Bundle.main.path(forResource: "en", ofType: "lproj") {
                path = Bundle(path: aType)!
            }
        }
        
        let str: String = NSLocalizedString(a_str, tableName: "LocalizableHomeSalon", bundle: path!, value: "", comment: "")
        
        return str
    }
    
    func changeLanguage() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let englishAction: UIAlertAction = UIAlertAction(title: "English", style: .default) { action -> Void in
            
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "en")
            MOLH.reset(transition: .transitionCrossDissolve)
            UserDefaults.standard.set(ENGLISH_LANGUAGE, forKey: "currentLanguage")
            //self.viewWillAppear(true)
            self.viewDidLoad()
            
        }
        let arabicAction: UIAlertAction = UIAlertAction(title: "العربية", style: .default) { action -> Void in
            
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "ar" ? "ar" : "ar")
            MOLH.reset(transition: .transitionCrossDissolve)
            UserDefaults.standard.set(ARABIC_LANGUAGE, forKey: "currentLanguage")
            self.viewDidLoad()
            //self.viewWillAppear(true)
            
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(englishAction)
        actionSheetController.addAction(arabicAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func showToastForAlert(message : String) {
        
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
        
        let duration: Double = 2
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func showToastForInternet (message : String) {
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
        // duration in seconds
        let duration: Double = 3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }

    

//    func showToastForAlert(message : String) {
//
//        let message = message
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//
//        self.present(alert, animated: true)
//        // duration in seconds
//        let duration: Double = 3
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
//            alert.dismiss(animated: true)
//
//        }
//
//        func showToastForInternet (message : String) {
//
//            let message = message
//            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//
//            self.present(alert, animated: true)
//            // duration in seconds
//            let duration: Double = 3
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
//
//                alert.dismiss(animated: true)
//
//            }
//
//
//        }
//
//    }
//
    
   
    
    //hexa code for color
   
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}



extension UIColor {
    
    convenience init(hexString: String) {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt32()
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    
    
    
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


extension UITextField {
    func setBottomLineBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UITextField {
    func setBottomLineBorderLightColor() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIImage{
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func squareMyImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.size.height, height: self.size.height))
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

//final class Singleton {
//
//    // Can't init is singleton
//    private init() { }
//
//    // MARK: Shared Instance
//
//    static let shared = Singleton()
//
//    // MARK: Local Variable
//
//    var myfilterData = [[String:Any]]()
//
//    var isFilterApplied = Bool()
//
//    var searchData = [[String:Any]]()
//    var isSearchApplied = Bool()
//
//}


//func languageChangeString(a_str: String) -> String?{
//    
//    var path: Bundle?
//    var selectedLanguage:String = String()
//    
//    //selectedLanguage = UserDefaults.standard.string(forKey: "currentLanguage")!
//    selectedLanguage = UserDefaults.standard.string(forKey: "currentLanguage") ?? ""
//    //let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
//    print(selectedLanguage)
//    
//    if selectedLanguage == "en" {
//        
//        if let aType = Bundle.main.path(forResource: "en", ofType: "lproj") {
//            path = Bundle(path: aType)!
//        }
//    }
//    else if selectedLanguage == "ar" {
//        if let aType = Bundle.main.path(forResource: "ar", ofType: "lproj") {
//            path = Bundle(path: aType)!
//        }
//    }
//    else {
//        if let aType = Bundle.main.path(forResource: "en", ofType: "lproj") {
//            path = Bundle(path: aType)!
//        }
//    }
//    
//    let str: String = NSLocalizedString(a_str, tableName: "Localizable", bundle: path!, value: "", comment: "")
//    
//    return str
//}




//// Valodation Toasts

//extension UIViewController {
//
//    func showToastForAlert(message : String) {
//
//        CRNotifications.showNotification(type: CRNotifications.success, title: languageChangeString(a_str: "Success")!, message: message, dismissDelay: 2, completion: {
//        })
//    }
//
//    func showToastForError(message : String) {
//
//        CRNotifications.showNotification(type: CRNotifications.error, title: languageChangeString(a_str: "Error")!, message: message, dismissDelay: 2)
//    }
//}

