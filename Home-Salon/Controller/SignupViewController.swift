//
//  SignupViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 29/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire


class SignupViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var IBANNumberTF: UITextField!
    @IBOutlet var noOfProvidersTF: UITextField!
    @IBOutlet var createPasswordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet var createShowBtn: UIButton!
    @IBOutlet var confirmShowBtn: UIButton!
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var homeServiceCheckBtn: UIButton!
    @IBOutlet var salonCheckBtn: UIButton!
    @IBOutlet var serviceStackView: UIStackView!
    @IBOutlet var salonStackView: UIStackView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var salonBtnHt: NSLayoutConstraint!
    @IBOutlet weak var homeServiceBtnHt: NSLayoutConstraint!
    
    @IBOutlet weak var signUpSt: UILabel!
    
    @IBOutlet weak var salonSt: UILabel!
    
    @IBOutlet weak var termsCondSt: UIButton!
    @IBOutlet weak var iagreeSt: UILabel!
    @IBOutlet weak var homeserviceSt: UILabel!
    @IBOutlet weak var bothSt: UILabel!
    @IBOutlet weak var bothServicesBtn: UIButton!
    
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var alreadyhaveAccSt: UILabel!
    
    @IBOutlet weak var signInNowBtn: UIButton!
    
    var userTypeString : String?
    var serviceType = "3"
    
    //for map
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTF.delegate = self
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
           self.loadCustomView()
        
        
        self.createPasswordTF.isSecureTextEntry = true
        self.confirmPasswordTF.isSecureTextEntry = true
        
        
          NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    @objc func getLocation(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String
            longitudeString = dict["key1"] as? String
            addressStr = dict["key2"] as? String
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
        }
        
        self.locationTF.text = addressStr
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
         if textField == locationTF
         {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
             self.view.endEditing(true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func languageChangeBtnTap(_ sender: Any)
    {
        changeLanguage()
    }
    
    
    
    func loadCustomView(){
        
        self.createShowBtn.tag = 1
        self.confirmShowBtn.tag = 1
        self.agreeBtn.tag = 1
        self.bothServicesBtn.setImage(UIImage.init(named: "SelectedRadio"), for: UIControl.State.normal)
        self.homeServiceCheckBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        self.salonCheckBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        self.nameTF.layer.borderColor = ThemeColor
        self.nameTF.layer.borderWidth = 1.0
   
        self.emailTF.layer.borderColor = ThemeColor
        self.emailTF.layer.borderWidth = 1.0
        
        self.phoneNumberTF.layer.borderColor = ThemeColor
        self.phoneNumberTF.layer.borderWidth = 1.0
        
        self.IBANNumberTF.layer.borderColor = ThemeColor
        self.IBANNumberTF.layer.borderWidth = 1.0
        
        self.noOfProvidersTF.layer.borderColor = ThemeColor
        self.noOfProvidersTF.layer.borderWidth = 1.0
        
        self.createPasswordTF.layer.borderColor = ThemeColor
        self.createPasswordTF.layer.borderWidth = 1.0
        
        self.confirmPasswordTF.layer.borderColor = ThemeColor
        self.confirmPasswordTF.layer.borderWidth = 1.0
        
        self.locationTF.layer.borderColor = ThemeColor
        self.locationTF.layer.borderWidth = 1.0
        
        self.signUpBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)
        self.signInNowBtn.setTitle(languageChangeString(a_str: "Sign in Now!"), for: UIControl.State.normal)
        self.termsCondSt.setTitle(languageChangeString(a_str: "Terms and Conditions"), for: UIControl.State.normal)
        
        
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
            self.IBANNumberTF.textAlignment = .right
            self.IBANNumberTF.setPadding(left: -10, right: -10)
            self.noOfProvidersTF.textAlignment = .right
            self.noOfProvidersTF.setPadding(left: -10, right: -10)
            self.locationTF.textAlignment = .right
            self.locationTF.setPadding(left: -10, right: -10)
           
            
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
            self.IBANNumberTF.textAlignment = .left
            self.IBANNumberTF.setPadding(left: 10, right: 10)
            self.noOfProvidersTF.textAlignment = .left
            self.noOfProvidersTF.setPadding(left: 10, right: 10)
            self.locationTF.textAlignment = .left
            self.locationTF.setPadding(left: 10, right: 10)
            
        }
        
        self.nameTF.placeholder = languageChangeString(a_str: "Name")
        self.emailTF.placeholder = languageChangeString(a_str: "E-mail Address")
        self.phoneNumberTF.placeholder = languageChangeString(a_str: "Phone number")
        self.createPasswordTF.placeholder = languageChangeString(a_str: "Create password")
        self.confirmPasswordTF.placeholder = languageChangeString(a_str: "Confirm Password")
        self.IBANNumberTF.placeholder = languageChangeString(a_str: "IBAN Number")
        self.noOfProvidersTF.placeholder = languageChangeString(a_str: "Number of providers")
        self.locationTF.placeholder = languageChangeString(a_str: "Location")
        
        
        self.nameTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.emailTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.phoneNumberTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.createPasswordTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.confirmPasswordTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.locationTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.IBANNumberTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        self.noOfProvidersTF.placeholderColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.8980392157, alpha: 1)
        
        
        self.signUpSt.text = languageChangeString(a_str: "Sign up")
        self.alreadyhaveAccSt.text = languageChangeString(a_str: "Already have an account?")
        self.iagreeSt.text = languageChangeString(a_str: "I agree to the")
        self.bothSt.text = languageChangeString(a_str: "Both")
        self.homeserviceSt.text = languageChangeString(a_str: "Home Services")
        self.salonSt.text = languageChangeString(a_str: "At the Salon")
        
        
    }
    
    

    @IBAction func backBtnAction(_ sender: Any) {
       
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signInNowBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func locationBtnTap(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
        
        navigationController?.pushViewController(vc, animated: true)
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
   
    
    @IBAction func termsConditionsBtnTap(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsCondVC")as! TermsCondVC
        vc.checkStr = "terms"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func botrhBtnTap(_ sender: Any)
    {
        self.bothServicesBtn.setImage(UIImage.init(named: "SelectedRadio"), for: UIControl.State.normal)
        self.homeServiceCheckBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        self.salonCheckBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        serviceType = "3"
    }
    @IBAction func homeServiceBtnAction(_ sender: Any) {
        self.homeServiceCheckBtn.setImage(UIImage.init(named: "SelectedRadio"), for: UIControl.State.normal)
        self.bothServicesBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        self.salonCheckBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        serviceType = "1"
    }
    
    @IBAction func salonBtnAction(_ sender: Any) {
        self.salonCheckBtn.setImage(UIImage.init(named: "SelectedRadio"), for: UIControl.State.normal)
        self.bothServicesBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        self.homeServiceCheckBtn.setImage(UIImage.init(named: "UnSelectedRadio"), for: UIControl.State.normal)
        serviceType = "2"
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
        self.emailTF.text == nil || self.emailTF.text == "" || self.phoneNumberTF.text == nil || self.phoneNumberTF.text == "" || self.locationTF.text == nil || self.locationTF.text == ""
    {
        
        showToastForAlert(message:"Please Enter All Fields")
        
        return
     }
    
    
    

    if MobileFixServices.sharedInstance.isValidEmail(testStr: emailTF.text ?? "") == false
    {
        showToastForAlert(message:"Please enter valid email")
        return
    }
    
    
    if confirmPasswordTF.text != createPasswordTF.text
    {
        
        showToastForAlert(message:"Password and confirm password are didnot match")
        
        
        return
    }
    
    
    if agreeBtn.tag == 0
    {
        
      
        showToastForAlert(message:"Please Agree Terms And Conditions")
        return
    }
    
    if Reachability.isConnectedToNetwork()
    {
    
       MobileFixServices.sharedInstance.loader(view: self.view)
       
//        https://www.volive.in/spsalon/services/ownerregistration
//        Registration (POST method)
//
//        api_key:2382019
//        lang:en
//        name:
//        phone:
//        email:
//        password:
//        device_name:(android/ios)
//        device_token:
//        agree_tc:(0=not agree,1= agree to terms_and_conditions)
//        employees:
//        iban_number:
//        service_type: (Home Service, Salon)
//        gender: (1->male, 2->female)(Optional)
        
        
        let signup = "\(base_path)services/ownerregistration"
    
    
        let parameters: Dictionary<String, Any> = [ "name" :nameTF.text ?? "", "email":self.emailTF.text ?? "" ,"password" : self.confirmPasswordTF.text ?? "" , "agree_tc" :agreeBtn.tag , "device_name" : DEVICETYPE, "device_token" : DEVICE_TOKEN , "lang" : language,"api_key":APIKEY,"phone":phoneNumberTF.text ?? "","employees":noOfProvidersTF.text ?? "","iban_number":IBANNumberTF.text ?? "","service_type":serviceType,"location":locationTF.text ?? "","longitude":longitudeString ?? "","latitude":latitudeString ?? ""]
        
        
      
        print(parameters)
        
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                     MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if let userDetailsData = responseData["data"] as? Dictionary<String, AnyObject> {
                        
                        print(userDetailsData)
                        let userName = userDetailsData["name"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let userId = userDetailsData["user_id"] as? String?
                        let userPhone = userDetailsData["phone"] as? String?
            
                        //UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(userPhone as Any, forKey: "userPhone")
                        
                        UserDefaults.standard.set(userId as Any, forKey: USER_ID)
                       
                    }
                    
                    DispatchQueue.main.async {
                        
                        
                        let VerificationVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                        VerificationVC.userTypeString = self.userTypeString
                       // VerificationVC.originalOtp = "ServiceProvider"
                        self.navigationController?.pushViewController(VerificationVC, animated: true)
                        
                        //self.showToastForAlert(message: message)
                        
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
//["base_url": https://www.volive.in/spsalon/, "message": Registration successful, "data": {
//    "auth_level" = 1;
//    "avalability_status" = 1;
//    city = "";
//    country = "";
//    "device_name" = iOS;
//    "device_token" = 0123456;
//    "display_pic" = "uploads/default-user.png";
//    email = "sai@gmail.com";
//    employees = 0;
//    gender = 0;
//    "iban_number" = "";
//    location = "";
//    "login_type" = "";
//    name = test;
//    "old_token" = 0123456;
//    "online_status" = 1;
//    password = 202cb962ac59075b964b07152d234b70;
//    phone = 9999999999;
//    "register_on" = "2019-08-27 06:58:09";
//    "service_type" = "";
//    "unique_id" = "";
//    "update_on" = "2019-08-27 00:58:09";
//    "user_id" = 8;
//    "user_status" = 1;
//}, "status": 1]
//["unique_id": , "service_type": , "display_pic": uploads/default-user.png, "country": , "auth_level": 1, "login_type": , "device_name": iOS, "city": , "name": test, "old_token": 0123456, "location": , "update_on": 2019-08-27 00:58:09, "password": 202cb962ac59075b964b07152d234b70, "avalability_status": 1, "online_status": 1, "phone": 9999999999, "employees": 0, "email": sai@gmail.com, "iban_number": , "register_on": 2019-08-27 06:58:09, "user_id": 8, "device_token": 0123456, "gender": 0, "user_status": 1]

