//
//  ForgotPasswordVC.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 7/5/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire


class ForgotPasswordVC: UIViewController
{

    @IBOutlet weak var forgotSt: UILabel!
    @IBOutlet weak var useEmailTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.forgotSt.text = languageChangeString(a_str: "Forgot Password")
       self.useEmailTF.placeholder = languageChangeString(a_str: "E-mail Address")
       self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        if language == "ar"
        {
            
            self.useEmailTF.textAlignment = .right
            self.useEmailTF.setPadding(left: -10, right: -10)
           
            
            
        }
        else if language == "en"{
            
            self.useEmailTF.textAlignment = .left
            self.useEmailTF.setPadding(left: 10, right: 10)
         
            
            
        }
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    
    @IBAction func backBtnTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitBtnTap(_ sender: Any)
    {
        forgotPassword()
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
 
    
// forgot password service call
    
  func forgotPassword()
  {
    //internet connection
    
      if Reachability.isConnectedToNetwork()
      {
        MobileFixServices.sharedInstance.loader(view: self.view)
    
         let forgot = "\(base_path)services/forgot_password"
        
       
        
//        https://www.volive.in/spsalon/services/forgot_password
//        Forgot password for all users (POST method)
//
//         api_key:2382019
//        lang:en
//        email:
   
        
    
           let parameters: Dictionary<String, Any> = ["email":self.useEmailTF.text ?? "","lang":language,"api_key":APIKEY]
    
           print(parameters)
    
         Alamofire.request(forgot, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                 print(responseData)
    
               let status = responseData["status"] as! Int
               let message = responseData["message"] as! String
    
               if status == 1
               {
                
                MobileFixServices.sharedInstance.dissMissLoader()
                 self.showToastForAlert(message: message)
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3.1)
                 {
                     self.dismiss(animated: true, completion: nil)
                 }
    
                }
                else
                   {
                       MobileFixServices.sharedInstance.dissMissLoader()
                       self.showToastForAlert(message: message)
                    
                    }
               }
           }
      }
        else
        {
              MobileFixServices.sharedInstance.dissMissLoader()
             showToastForAlert (message:"Please ensure you have proper internet connection")
         }
    
    }
    
}
