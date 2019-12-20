//
//  SignInTypeViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 29/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class SignInTypeViewController: UIViewController {
   
    var signInTypeString : String?
    
    @IBOutlet var serviceProviderBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userBtn.setTitle(languageChangeString(a_str: "USER"), for: UIControl.State.normal)
        self.serviceProviderBtn.setTitle(languageChangeString(a_str: "SERVICE PROVIDER"), for: UIControl.State.normal)
        
        self.serviceProviderBtn.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.serviceProviderBtn.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func backBtnTap(_ sender: Any)
    {
        let signInType = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GatewayViewController") as! GatewayViewController
        self.navigationController?.pushViewController(signInType, animated: true)
    }
    
    @IBAction func userBtnAction(_ sender: Any) {
        
        self.signInTypeString = "user"
        UserDefaults.standard.set(signInTypeString, forKey: "type")
       let signIn = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signIn.userTypeString = "user"
        
        UserDefaults.standard.set(self.signInTypeString as Any, forKey: "type2")
        
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    
    @IBAction func languageChangeBtn(_ sender: Any)
    {
        changeLanguage()
    }
    
    
    @IBAction func serviceProviderBtnAction(_ sender: Any) {
        self.signInTypeString = "provider"
        UserDefaults.standard.set(signInTypeString, forKey: "type")
        let signIn = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signIn.userTypeString = "provider"
        UserDefaults.standard.set(self.signInTypeString as Any, forKey: "type2")
        self.navigationController?.pushViewController(signIn, animated: true)
    }
}
