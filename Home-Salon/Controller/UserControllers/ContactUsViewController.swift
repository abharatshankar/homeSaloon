//
//  ContactUsViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class ContactUsViewController: UIViewController {
    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var messageSt: UILabel!
    @IBOutlet weak var phonenumberSt: UILabel!
    @IBOutlet weak var emailSt: UILabel!
    @IBOutlet weak var nameSt: UILabel!
    @IBOutlet weak var addNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         self.title = languageChangeString(a_str: "Contact Us")
        self.nameSt.text = languageChangeString(a_str: "Name")
        self.emailSt.text = languageChangeString(a_str: "Email")
        self.phonenumberSt.text = languageChangeString(a_str: "Phone number")
        self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        
//        self.messageSt.text = languageChangeString(a_str: "Cost")
//
//        self.addNameTF.placeholder = languageChangeString(a_str: "Password")
//        self.emailTF.placeholder = languageChangeString(a_str: "E-mail")
//        self.phoneTF.placeholder = languageChangeString(a_str: "Password")
//        self.messageTF.placeholder = languageChangeString(a_str: "E-mail")
        
        if language == "ar"
        {
            
            self.addNameTF.textAlignment = .right
            self.addNameTF.setPadding(left: -10, right: -10)
            self.emailTF.textAlignment = .right
            self.emailTF.setPadding(left: -10, right: -10)
            self.phoneTF.textAlignment = .right
            self.phoneTF.setPadding(left: -10, right: -10)
            self.messageTF.textAlignment = .right
            self.messageTF.setPadding(left: -10, right: -10)
            
            
            
        }
        else if language == "en"{
            
            self.emailTF.textAlignment = .left
            self.emailTF.setPadding(left: 10, right: 10)
            self.addNameTF.textAlignment = .left
            self.addNameTF.setPadding(left: 10, right: 10)
            self.phoneTF.textAlignment = .left
            self.phoneTF.setPadding(left: 10, right: 10)
            self.messageTF.textAlignment = .left
            self.messageTF.setPadding(left: 10, right: 10)
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuBtnAction(_ sender: Any) {
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitBtnTap(_ sender: Any)
    {
        
        let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        if self.addNameTF.text == nil || self.addNameTF.text == "" || self.emailTF?.text == nil || self.emailTF.text == "" ||
            self.messageTF.text == nil || self.messageTF.text == "" ||
            self.phoneTF.text == nil || self.phoneTF.text == ""
        {
            
            showToastForAlert(message:languageChangeString(a_str:"Please Enter All Fields")!)
            
            return
        }
        
        if MobileFixServices.sharedInstance.isValidEmail(testStr: emailTF.text ?? "") == false
        {
            showToastForAlert(message:languageChangeString(a_str:"Please enter valid email")!)
            return
        }
        
    
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
           
            //    https://www.volive.in/spsalon/services/contact_us
            //    Contact Us (POST method)
            //
            //    api_key:2382019
            //    lang:en
            //    name:
            //    email:
            //    phone:
            //    message:

            
            let contactUs = "\(base_path)services/contact_us"
            
            let parameters: Dictionary<String, Any> = [ "name" :addNameTF.text ?? "", "email":self.emailTF.text ?? "" , "lang" :language,"api_key":APIKEY,"phone":phoneTF.text ?? "","message":self.messageTF.text ?? "","user_id":myuserID]
            
            print(parameters)
            
            Alamofire.request(contactUs, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                      
                        DispatchQueue.main.async {
                            self.showToastForAlert(message: message)
                            
                           
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                                let userHome =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController")
                                
                                self.present(userHome, animated: true, completion: nil)
                                
                               
                            }
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        print(message)
                    }
                }
            }
            
        }
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    
    
    }
    
    
    

}
