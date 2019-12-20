//
//  VerificationVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 30/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire

class VerificationVC: UIViewController,UITextFieldDelegate{

    @IBOutlet var otpOneTF: UITextField!
    @IBOutlet var otpTwoTF: UITextField!
    @IBOutlet var otpThreeTF: UITextField!
    @IBOutlet var otpFourTF: UITextField!
    @IBOutlet weak var verificationSt: UILabel!
    
    @IBOutlet weak var enterUrotpSt: UILabel!
    
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var verifyMobileSt: UILabel!
    
    @IBOutlet weak var resendCodeBtn: UIButton!
    
    @IBOutlet weak var didnotReceiveCodest: UIButton!
    
    //var originalOtp = ""
    var userTypeString : String?
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
                self.otpOneTF.delegate = self
        self.otpTwoTF.delegate = self
        self.otpThreeTF.delegate = self
        self.otpFourTF.delegate = self

        self.otpOneTF.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.otpOneTF.layer.borderWidth = 2.0
        self.otpTwoTF.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.otpTwoTF.layer.borderWidth = 2.0
        self.otpThreeTF.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.otpThreeTF.layer.borderWidth = 2.0
        self.otpFourTF.layer.borderColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        self.otpFourTF.layer.borderWidth = 2.0
                otpOneTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpTwoTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpThreeTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpFourTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        self.verifyBtn.setTitle(languageChangeString(a_str: "VERIFY"), for: UIControl.State.normal)
        self.resendCodeBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.verificationSt.text = languageChangeString(a_str: "Verification")
        self.verifyMobileSt.text = languageChangeString(a_str: "Verify your mobile")
        self.enterUrotpSt.text = languageChangeString(a_str: "Enter your OTP CODE here")
        self.didnotReceiveCodest.setTitle(languageChangeString(a_str: "Didn't receive the code?"), for: UIControl.State.normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigate), name: NSNotification.Name(rawValue: "navigate1"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        otpOneTF.becomeFirstResponder()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
       
        let text = textField.text
       
        if  text?.count == 1 {
            switch textField{
            case otpOneTF:
                otpTwoTF.becomeFirstResponder()
            case otpTwoTF:
                otpThreeTF.becomeFirstResponder()
            case otpThreeTF:
                otpFourTF.becomeFirstResponder()
            case otpFourTF:
                otpFourTF.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case otpOneTF:
                otpOneTF.becomeFirstResponder()
            case otpTwoTF:
                otpOneTF.becomeFirstResponder()
            case otpThreeTF:
                otpTwoTF.becomeFirstResponder()
            case otpFourTF:
                otpThreeTF.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        
        let currentString: NSString = textField.text! as NSString
        
        let newString: NSString =
            
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        
    }
    
    
    
    @objc func navigate(){
        let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController")as! SignInViewController
        self.present(VC, animated: true, completion: nil)
    }

    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func verifyBtnAction(_ sender: Any) {
        
        if self.otpOneTF.text == nil || self.otpOneTF.text == "" || self.otpTwoTF.text == nil || self.otpTwoTF.text == "" || self.otpThreeTF?.text == nil || self.otpThreeTF?.text == "" || self.otpFourTF.text == "" || self.otpThreeTF?.text == nil
            
        {
            
            showToastForAlert(message:"Please Enter 4 Digit Password")
            
            return
        }
        
        if let myUserid = UserDefaults.standard.object(forKey: USER_ID) as? String{
            if myUserid == ""{
                showToastForAlert(message:"No user id registered yet ")
                return
            }
        }
        else{
            showToastForAlert(message:"No user id registered yet ")
            return
        }
        
        otpVerificationService(pass1: self.otpOneTF.text!, pass2: self.otpTwoTF.text!, pass3: self.otpThreeTF.text!, pass4: self.otpFourTF.text! , userid : UserDefaults.standard.object(forKey: USER_ID) as? String ?? "" )
        
        

       
    }
    
    func otpVerificationService(pass1 : String , pass2 : String ,pass3 : String ,pass4 : String , userid : String)  {
    
        if Reachability.isConnectedToNetwork()
        {

            MobileFixServices.sharedInstance.loader(view: self.view)


            let myotp = pass1 + pass2 + pass3 + pass4

            let parameters: Dictionary<String, Any> = ["user_id": userid ,"otp" : myotp , "lang" : "en","api_key":APIKEY]

            print(parameters)

        Alamofire.request(VERIFY_OTP, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ (response:DataResponse<Any>) in

                switch(response.result)
                {
                case .success(_):

                    guard let data = response.data, response.result.error == nil else { return }

                    do {

                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>

                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String

                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()

                        DispatchQueue.main.async {
                               // if(self.originalOtp == pass1 + pass2 + pass3 + pass4){
                                    if self.userTypeString == "user"{
                                        let userHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController")
                                       
                                        self.present(userHome, animated: true, completion: nil)
                                    }
                                    else{
       
                                
                                        let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVerificationViewController")as! AccountVerificationViewController
                                        self.present(VC, animated: true, completion: nil)
                                        
                                       //UserDefaults.standard.set("false" as Any, forKey: "bool")
                                   }
                            }
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            print(message)
                        }
                    }catch let error as NSError {
                        print(error)
                        MobileFixServices.sharedInstance.dissMissLoader()
                    }
                    break

                case .failure(_):
                    MobileFixServices.sharedInstance.dissMissLoader()
                    print(response.result.error ?? "")
                    break

                }
            }

        }
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            self.showToastForAlert(message:"Please ensure you have proper internet connection")

        }

    }
    
    
    @IBAction func resendOtpBtnTap(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
        
            let phoneNum = UserDefaults.standard.object(forKey: "userPhone") ?? ""
            
            let parameters: Dictionary<String, Any> = ["phone":phoneNum,"lang" : "en","api_key":APIKEY]
            
            print(parameters)
            
            
            //        https://www.volive.in/spsalon/services/resend_otp
            //        Resend OTP (POST method)
            //
            //        api_key:2382019
            //        lang:en
            //        phone
            
            
            let otpResend = "\(base_path)services/resend_otp"
            
          Alamofire.request(otpResend, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        
                        let status = responseData?["code"] as! Int
                        let message = responseData?["message"] as! String
                        let des = responseData?["description"] as! String
                         let otp = responseData?["otp"] as! Int
                       
                        if status == 200
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            
                        DispatchQueue.main.async {
                            
                             self.showToastForAlert(message: message)
//                             let recentOtp = String(otp)
//
//                              self.showToastForAlert(message: recentOtp)
                            
                        }
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            print(message)
                        }
                    }catch let error as NSError {
                        print(error)
                        MobileFixServices.sharedInstance.dissMissLoader()
                    }
                    break
                    
                case .failure(_):
                    MobileFixServices.sharedInstance.dissMissLoader()
                    print(response.result.error ?? "")
                    break
                    
                }
            }
            
        }
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            self.showToastForAlert(message:"Please ensure you have proper internet connection")
            
        }
    
    
    }
    
    
    
}
