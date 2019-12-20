//
//  ViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 26/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import MOLH

class GatewayViewController: UIViewController {

    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet var guestUserBtn: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.guestUserBtn.setTitle(languageChangeString(a_str: "GUEST USER"), for: UIControl.State.normal)
        
        self.guestUserBtn.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.guestUserBtn.layer.borderWidth = 1.0
        // Do any additional setup after loading the view, typically from a nib.
    }

     override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
       
    }
    
    @IBAction func guestUserBtnAction(_ sender: Any) {
        let userHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController")
        
        UserDefaults.standard.set("" as Any, forKey: "userName")
        
        //userHome.userType = "guest"
         UserDefaults.standard.set("user", forKey: "type")
        self.present(userHome, animated: true, completion: nil)
    }
    @IBAction func signInBtnAction(_ sender: Any) {
        let signInType = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInTypeViewController") as! SignInTypeViewController
        

        self.navigationController?.pushViewController(signInType, animated: true)
    }
    
    
    @IBAction func languageChangeBtnTap(_ sender: Any)
    {
        
        changeLanguage()
        
    }
    
    
//
//    func changeLanguage() {
//        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let englishAction: UIAlertAction = UIAlertAction(title: "English", style: .default) { action -> Void in
//
//            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "en")
//            MOLH.reset(transition: .transitionCrossDissolve)
//            UserDefaults.standard.set(ENGLISH_LANGUAGE, forKey: "currentLanguage")
//            //self.viewWillAppear(true)
//            self.viewDidLoad()
//
//        }
//        let arabicAction: UIAlertAction = UIAlertAction(title: "العربية", style: .default) { action -> Void in
//
//            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "ar" ? "ar" : "ar")
//            MOLH.reset(transition: .transitionCrossDissolve)
//            UserDefaults.standard.set(ARABIC_LANGUAGE, forKey: "currentLanguage")
//            self.viewDidLoad()
//            //self.viewWillAppear(true)
//
//        }
//        let cancelAction: UIAlertAction = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { action -> Void in }
//
//        actionSheetController.addAction(englishAction)
//        actionSheetController.addAction(arabicAction)
//        actionSheetController.addAction(cancelAction)
//        present(actionSheetController, animated: true, completion: nil)
//    }
}

