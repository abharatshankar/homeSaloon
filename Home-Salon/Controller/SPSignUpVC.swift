//
//  SPSignUpVC.swift
//  Home-Salon
//
//  Created by harshitha on 27/08/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class SPSignUpVC: UIViewController {
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var createPasswordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
     @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var createShowBtn: UIButton!
    @IBOutlet var confirmShowBtn: UIButton!
    @IBOutlet weak var iagreeSt: UILabel!
    @IBOutlet weak var signUpSt: UILabel!
    @IBOutlet weak var termsCondiBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var alreadyHaveAccSt: UILabel!
    @IBOutlet weak var signInNowBtn: UIButton!
    var userTypeString : String?
    var myMsg = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
  	
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCustomView()
        
        createPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        
        self.signUpBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)
        self.signInNowBtn.setTitle(languageChangeString(a_str: "Sign in Now!"), for: UIControl.State.normal)
        self.termsCondiBtn.setTitle(languageChangeString(a_str: "Terms and Conditions"), for: UIControl.State.normal)
       
        
        if language == "ar"
        {
            self.nameTF.textAlignment = .right
            self.nameTF.setPadding(left: -10, right: -10)
            self.emailTF.textAlignment = .right
            self.emailTF.setPadding(left: -10, right: -10)
            self.phoneNumberTF.textAlignment = .right
            self.phoneNumberTF.setPadding(left: -10, right: -10)
            self.createPasswordTF.textAlignment = .right
            self.createPasswordTF.setPadding(left: -10, right: -10)
            self.confirmPasswordTF.textAlignment = .right
            self.confirmPasswordTF.setPadding(left: -10, right: -10)
            
            
        }
        else if language == "en"{
            self.nameTF.textAlignment = .left
            self.nameTF.setPadding(left: 10, right: 10)
            self.emailTF.textAlignment = .left
            self.emailTF.setPadding(left: 10, right: 10)
            self.phoneNumberTF.textAlignment = .left
            self.phoneNumberTF.setPadding(left: 10, right: 10)
            self.createPasswordTF.textAlignment = .left
            self.createPasswordTF.setPadding(left: 10, right: 10)
            self.confirmPasswordTF.textAlignment = .left
            self.confirmPasswordTF.setPadding(left: 10, right: 10)
            
        }
        
        self.nameTF.placeholder = languageChangeString(a_str: "Name")
        self.emailTF.placeholder = languageChangeString(a_str: "E-mail Address")
        self.phoneNumberTF.placeholder = languageChangeString(a_str: "Phone number")
        self.createPasswordTF.placeholder = languageChangeString(a_str: "Create password")
        self.confirmPasswordTF.placeholder = languageChangeString(a_str: "Confirm Password")
        self.nameTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.emailTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.phoneNumberTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.createPasswordTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.confirmPasswordTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        
        
        self.signUpSt.text = languageChangeString(a_str: "Sign up")
        self.alreadyHaveAccSt.text = languageChangeString(a_str: "Already have an account?")
        self.iagreeSt.text = languageChangeString(a_str: "I agree to the")
        
        // Do any additional setup after loading the view.
    }
    
    func loadCustomView(){
        self.createShowBtn.tag = 1
        self.confirmShowBtn.tag = 1
        self.agreeBtn.tag = 1
      
        self.nameTF.layer.borderColor = ThemeColor
        self.nameTF.layer.borderWidth = 1.0
        
        self.emailTF.layer.borderColor = ThemeColor
        self.emailTF.layer.borderWidth = 1.0
        
        self.phoneNumberTF.layer.borderColor = ThemeColor
        self.phoneNumberTF.layer.borderWidth = 1.0
        
        self.createPasswordTF.layer.borderColor = ThemeColor
        self.createPasswordTF.layer.borderWidth = 1.0
        
        self.confirmPasswordTF.layer.borderColor = ThemeColor
        self.confirmPasswordTF.layer.borderWidth = 1.0
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func signInNowBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsConditionsBtnTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsCondVC")as! TermsCondVC
        vc.checkStr = "terms"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func createShowBtnAction(_ sender: Any) {
        if self.createShowBtn.tag == 1 {
            self.createPasswordTF.isSecureTextEntry = false
            self.createShowBtn.setImage(UIImage.init(named: "PasswordShow"), for: UIControl.State.normal)
            self.createShowBtn.tag = 2
        }
        else{
            self.createPasswordTF.isSecureTextEntry = true
            self.createShowBtn.setImage(UIImage.init(named: "PasswordHide"), for: UIControl.State.normal)
            self.createShowBtn.tag = 1
        }
    }
    
    @IBAction func confirmShowBtnAction(_ sender: Any) {
        if self.confirmShowBtn.tag == 1 {
            self.confirmPasswordTF.isSecureTextEntry = false
            self.confirmShowBtn.setImage(UIImage.init(named: "PasswordShow"), for: UIControl.State.normal)
            self.confirmShowBtn.tag = 2
        }
        else{
            self.confirmPasswordTF.isSecureTextEntry = true
            self.confirmShowBtn.setImage(UIImage.init(named: "PasswordHide"), for: UIControl.State.normal)
            self.confirmShowBtn.tag = 1
        }
    }
    
    @IBAction func languageChangeBtn(_ sender: Any) {
         changeLanguage()
    }
    
    
    @IBAction func agreeBtnAction(_ sender: Any) {
        if self.agreeBtn.tag == 1 {
            self.agreeBtn.setImage(UIImage.init(named: "unCheck"), for: UIControl.State.normal)
            self.agreeBtn.tag = 0
        }
        else{
            self.agreeBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
            self.agreeBtn.tag = 1
        }
        
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        
        signUpServicecall()
        
    }
    
    func signUpServicecall()
    {
        
        if self.nameTF.text == nil || self.nameTF.text == "" || self.confirmPasswordTF?.text == nil || self.confirmPasswordTF.text == "" ||
            self.createPasswordTF.text == nil || self.createPasswordTF.text == "" ||
            self.emailTF.text == nil || self.emailTF.text == "" || self.phoneNumberTF.text == nil || self.phoneNumberTF.text == ""
        {
            
            showToastForAlert(message:languageChangeString(a_str:"Please Enter All Fields")!)
            
            return
        }
        
        if MobileFixServices.sharedInstance.isValidEmail(testStr: emailTF.text ?? "") == false
        {
            showToastForAlert(message:"Please enter valid email")
            return
        }
        
        
        if confirmPasswordTF.text != createPasswordTF.text
        {
            
            showToastForAlert(message:languageChangeString(a_str:"Password and confirm password are didnot match")!)
            
            
            return
        }
        
        
        if agreeBtn.tag == 0
        {
            
            //showToastForAlert(message:languageChangeString(a_str:"Please Agree Terms And Conditions") ?? "")
            showToastForAlert(message:languageChangeString(a_str:"Please Agree Terms And Conditions")!)
            return
        }
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            //https://www.volive.in/spsalon/services/registration
           
            let signup = "\(base_path)services/registration"
            
            
            let parameters: Dictionary<String, Any> = [ "name" :nameTF.text ?? "", "email":self.emailTF.text ?? "" ,"password" : self.confirmPasswordTF.text ?? "" , "agree_tc" :agreeBtn.tag , "device_name" : DEVICETYPE, "device_token" : DEVICE_TOKEN , "lang" : language,"api_key":APIKEY,"phone":phoneNumberTF.text ?? ""]
            
            print(parameters)
            
            Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    self.myMsg = message
                    if status == 1
                    {
                        var originalOtp = ""
                        MobileFixServices.sharedInstance.dissMissLoader()
                        if let userDetailsData = responseData["data"] as? Dictionary<String, AnyObject> {
                            
                            print(userDetailsData)
                            let userName = userDetailsData["name"] as? String?
                            let userEmail = userDetailsData["email"] as? String?
                            let userId = userDetailsData["user_id"] as? String?
                            let userPhone = userDetailsData["phone"] as? String?
                            if let myoriginalOtp = userDetailsData["otp"] as? String{
                                originalOtp = myoriginalOtp
                            }
                            
                            UserDefaults.standard.set(userName as Any, forKey: "userName")
                            UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                            UserDefaults.standard.set(userPhone as Any, forKey: "userPhone")
                            UserDefaults.standard.set(userId as Any, forKey: USER_ID)
                            
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.showToastForAlert(message: self.myMsg)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                                let VerificationVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                                VerificationVC.userTypeString = self.userTypeString
                                //VerificationVC.originalOtp = originalOtp
                                self.navigationController?.pushViewController(VerificationVC, animated: true)
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
extension UITextField {
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
}
