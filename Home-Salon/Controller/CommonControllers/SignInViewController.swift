//
//  SignInViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 29/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import FacebookLogin

class SignInViewController: UIViewController {

    @IBOutlet weak var signInSt: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var passwordShowBtn: UIButton!
    
    @IBOutlet weak var dontHaveAccountSt: UILabel!
    @IBOutlet weak var orSt: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var forgotPassBtn: UIButton!
    
    var userTypeString : String?
    var userTypeValue = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.loadCustomView()
        self.passwordTF.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnTap(_ sender: Any)
    {
        let signInType = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInTypeViewController") as! SignInTypeViewController
         self.navigationController?.pushViewController(signInType, animated: true)
    }
    
    func loadCustomView(){
        self.passwordShowBtn.tag = 1
        self.emailTF.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.emailTF.layer.borderWidth = 1.0
        
        self.passwordTF.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.passwordTF.layer.borderWidth = 1.0
        
            if self.userTypeString == "user"{
                userTypeValue = "1"
        }
            else{
                userTypeValue = "2"
        }
        
        self.signUpBtn.setTitle(languageChangeString(a_str: "Sign up"), for: UIControl.State.normal)
        self.signInBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.forgotPassBtn.setTitle(languageChangeString(a_str: "Forgot Your Password?"), for: UIControl.State.normal)
        self.googleBtn.setTitle(languageChangeString(a_str: "Google"), for: UIControl.State.normal)
        self.facebookBtn.setTitle(languageChangeString(a_str: "Facebook"), for: UIControl.State.normal)
        
        
        if language == "ar"
        {
            
            self.emailTF.textAlignment = .right
            self.emailTF.setPadding(left: -10, right: -10)
            self.passwordTF.textAlignment = .right
            self.passwordTF.setPadding(left: -10, right: -10)
           
            
            
        }
        else if language == "en"{
           
            self.emailTF.textAlignment = .left
            self.emailTF.setPadding(left: 10, right: 10)
            self.passwordTF.textAlignment = .left
            self.passwordTF.setPadding(left: 10, right: 10)
           
            
        }
        
     
        self.passwordTF.placeholder = languageChangeString(a_str: "Password")
        self.emailTF.placeholder = languageChangeString(a_str: "E-mail")
        self.passwordTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.emailTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.signInSt.text = languageChangeString(a_str: "Sign in")
        self.dontHaveAccountSt.text = languageChangeString(a_str: "Don't have an account?")
        //self.orSt.text = languageChangeString(a_str: "I agree to the")
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
         self.navigationController?.isNavigationBarHidden = true

        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @IBAction func languageChaneBtnTap(_ sender: Any)
    {
        changeLanguage()
    }
    
    @IBAction func forgotBtnTap(_ sender: Any) {
        let popUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.present(popUp, animated: true, completion: nil)
        
    }
    
    
  
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        if userTypeString == "user"
        {
            let signup = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPSignUpVC") as! SPSignUpVC
            signup.userTypeString = self.userTypeString
            self.navigationController?.pushViewController(signup, animated: true)
        }
        else{
            let signup = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            signup.userTypeString = self.userTypeString
            self.navigationController?.pushViewController(signup, animated: true)
        }
        
    }
    
    @IBAction func passwordShowBtnAction(_ sender: Any) {
        
        if self.passwordShowBtn.tag == 1 {
            self.passwordTF.isSecureTextEntry = false
            self.passwordShowBtn.setImage(UIImage.init(named: "PasswordShow"), for: UIControl.State.normal)
            self.passwordShowBtn.tag = 2
        }
        else{
            self.passwordTF.isSecureTextEntry = true
            self.passwordShowBtn.setImage(UIImage.init(named: "PasswordHide"), for: UIControl.State.normal)
            self.passwordShowBtn.tag = 1
        }
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        
          signInServicecall()
    }


  func signInServicecall()
  {
    
    if self.emailTF.text == nil || self.emailTF.text == "" || self.passwordTF?.text == nil || self.passwordTF.text == ""
      
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
        
      
        
        let signIn = "\(base_path)services/login"
       
        //https://www.volive.in/spsalon/services/login
        
//
//        api_key:2382019
//        lang:en
//        email:
//        password:
//        device_name:(android/ios)
//        device_token:
//        user_type: (1->user, 2->owner)
        
        
        let parameters: Dictionary<String, Any> = ["email":self.emailTF.text ?? "","password": self.passwordTF.text ?? "","device_name":DEVICETYPE,"device_token":DEVICE_TOKEN,"lang": language,"api_key":APIKEY,"user_type":userTypeValue]
        
        print(parameters)

        Alamofire.request(signIn, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response:DataResponse<Any>) in

            MobileFixServices.sharedInstance.dissMissLoader()
            
           switch(response.result)
            {
            case .success(_):

                guard let data = response.data, response.result.error == nil else { return }

                do {

                    let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>

                    let status = responseData?["status"] as! Int
                    let message = responseData?["message"] as! String
                     let otpStatus = responseData?["otp_status"] as! String

                if status == 1
                {
                    

                    if let userDetailsData = responseData?["data"] as? Dictionary<String, AnyObject> {

                        print(userDetailsData)
                        let userName = userDetailsData["name"] as? String
                        let userEmail = userDetailsData["email"] as? String
                        let userId = userDetailsData["user_id"] as? String
                        let userPhone = userDetailsData["phone"] as? String
                        var userpic = ""
                        if let pic = userDetailsData["display_pic"] as? String
                        {
                            userpic = base_path+pic
                        }
                        print(userpic)
                        
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(userPhone as Any, forKey: "userPhone")
                        UserDefaults.standard.set(userId as Any, forKey: USER_ID)
                        UserDefaults.standard.set(userpic as Any, forKey: "pic")
                        UserDefaults.standard.set(self.passwordTF.text, forKey: "password")
                       // self.showToastForAlert(message: message)
                    }

                    DispatchQueue.main.async {
                        
                        if self.userTypeString == "user"{
                            let userHome =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController")
                            userOrOwnerType = "1"
                            UserDefaults.standard.set("user" as Any, forKey: "type2")
                            self.present(userHome, animated: true, completion: nil)
                        }else
                        {
                            let SPHomeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPHomeVC1")
                            self.present(SPHomeVC, animated: true, completion: nil)
                        }

                    }
                }
           
            else if status == 0
            {
                if otpStatus == "0"
                {
                    
                    let userName = responseData?["name"] as? String
                    let userEmail = responseData?["email"] as? String
                    let userId = responseData?["user_id"] as? String
                    let userPhone = responseData?["phone"] as? String
                        var userpic = ""
                    if let pic = responseData?["display_pic"] as? String
                        {
                            userpic = base_path+pic
                        }
                        print(userpic)
                    
                    if self.userTypeString == "user"{
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                    }
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(userPhone as Any, forKey: "userPhone")
                        UserDefaults.standard.set(userId as Any, forKey: USER_ID)
                        UserDefaults.standard.set(userpic as Any, forKey: "pic")
                        // self.showToastForAlert(message: message)
                      
                    
                         DispatchQueue.main.async {
                        //                        self.showToastForAlert(message:message)
                        //                     DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                        let VerificationVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                        VerificationVC.userTypeString = self.userTypeString
                        //VerificationVC.originalOtp = "ServiceProvider"
                        self.navigationController?.pushViewController(VerificationVC, animated: true)
                        //}
                        
                    }
                }
                else
                {
                    self.showToastForAlert(message: message)
                }
                
             }
                else
                {
                    
                    self.showToastForAlert(message: message)
                    print(message)
                }
                }catch let error as NSError {
                    print(error)
                   
                }
                break

            case .failure(_):
               
                print(response.result.error ?? "")
                break

            }
        }
        
    }
    else
    {
       
        self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
        
    }
    
    }
    
    
    @IBAction func faceBookBtnTap(_ sender: Any)
    {
        let loginManager = LoginManager()
        //loginManager.loginBehavior = .browser
        
        loginManager.logIn(permissions: [.publicProfile, .email ], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    if let info = result as? [String : AnyObject]
                    {
                        
                        print(info)
                        print(info["name"] as! String)
                        
                        
                        if let myname = info["name"] as? String{
                            if let myEmail = info["email"] as? String{
                                if let myuserId = info["id"] as? String{
                                  
        
                                    self.socialSignup(name: myname, email: myEmail, unique_id: myuserId,login_type : "facebook" )
                                }
                            }
                            
                        }
                        
                    }
                    
                    
                }
                Connection.start()
                
            default:
                print("??")
            }
        }
    }
    
    func socialSignup(name: String , email : String , unique_id : String , login_type : String )  {
        print(name,email,unique_id)
        
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let signup = "\(base_path)services/social_login"
            
            
    
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
    
            let parameters: Dictionary<String, Any> = [
                "name" : name
                ,"email":email
                ,"login_type" : login_type
                ,"device_name" : DEVICETYPE
                ,"device_token" : DEVICE_TOKEN
                ,"lang" :language,"api_key":APIKEY
                ,"unique_id" : unique_id,"user_type":userTypeValue
            ]
            
            print("these are my params",parameters)
            
            Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    if status == 1
                    {
                        
                        
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
            showToastForAlert (message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
        
        
    }
    
    
 }
    

    
    
    




