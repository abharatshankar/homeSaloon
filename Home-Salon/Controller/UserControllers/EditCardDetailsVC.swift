//
//  EditCardDetailsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 16/02/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire

class EditCardDetailsVC: UIViewController {

    @IBOutlet var payNowBtn: UIButton!
   
    var checkStr : String?
  
    var params = [String:Any]()
    
    var cardTypeStr : String?
    var nameOnCardStr : String?
    var cardNumberStr : String?
    var cardExpiryDateStr : String?
    var cardCVVStr : String?
       
    @IBOutlet var enterCardDetailStaticLabel: UILabel!
    @IBOutlet var cardTypeStaticLabel: UILabel!
    @IBOutlet var cardNameStaticLabel: UILabel!
    @IBOutlet var cardNumberStaticLabel: UILabel!
    @IBOutlet var cardExpiryStaticLabel: UILabel!
    @IBOutlet var cvvStaticLabel: UILabel!
    @IBOutlet var secureSaveCardBtn: UIButton!
    
    @IBOutlet var cardTypeTF: UITextField!
    @IBOutlet var nameOnCardTF: UITextField!
    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var cardExpiryTF: UITextField!
    @IBOutlet var cvvTF: UITextField!
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var cardTypeString : String! = ""
    var card_type_idArray = [String]()
    var card_type_nameArray = [String]()

    var cardIdStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        enterCardDetailStaticLabel.text = languageChangeString(a_str: "ENTER YOUR CARD DETAILS")
//        cardTypeStaticLabel.text = languageChangeString(a_str:"Card Type")
//        cardNameStaticLabel.text = languageChangeString(a_str:"Name on Card")
//        cardNumberStaticLabel.text = languageChangeString(a_str:"Card Number")
//        cardExpiryStaticLabel.text = languageChangeString(a_str:"Card Expiry")
//        cvvStaticLabel.text = languageChangeString(a_str:"CVV")
//        secureSaveCardBtn.setTitle(languageChangeString(a_str: "Securely Save my Card For Future Use"), for: UIControl.State.normal)
      
        if checkStr == "addCard"{
            self.navigationItem.title = "Add card"
            self.payNowBtn.setTitle("Add card", for: UIControl.State.normal)
        }
        else{
            self.navigationItem.title = "Edit Card"
            self.payNowBtn.setTitle("Edit Card", for: UIControl.State.normal)
        }
        
        self.cardTypeTF.text = self.cardTypeStr
        print(cardTypeStr)
        self.nameOnCardTF.text = self.nameOnCardStr
        self.cardNumberTF.text = self.cardNumberStr
        self.cardExpiryTF.text = self.cardExpiryDateStr
        self.cvvTF.text = self.cardCVVStr
        
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
  
    
    @IBAction func payAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            addCardsServiceCall()
        }else
        {
            showToastForAlert (message: "Please ensure you have proper internet connection")
           
        }
     
    }
    
    //MARK: ADD CARDS SERVICE CALL
    func addCardsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
       
    
//        https://www.volive.in/spsalon/services/user_cards
//        User payment cards (POST method)
//
//        api_key:2382019
//        lang:en
//        user_id
//        name
//        expiry
//        card_type
//        card_number
//        cvv (optional)
//        card_id(for edit or update)
        
        let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        
        let addOreditCards = "\(base_path)services/user_cards"

       
       
        if checkStr == "addCard"{
            params = ["user_id" :myuserID,  "card_type" : cardTypeTF.text ?? "","card_number":cardNumberTF.text ?? "" ,"name" : nameOnCardTF.text!,"expiry" : cardExpiryTF.text ?? "" , "cvv" : cvvTF.text! , "lang" : "en","api_key":APIKEY,"card_id":cardIdStr ?? ""]
        }
        
        else{
            
            params = ["user_id" : myuserID,  "card_type" :cardTypeTF.text ?? "","card_number":cardNumberTF.text ?? "" ,"name" : nameOnCardTF.text!,"expiry" : cardExpiryTF.text ?? "" , "cvv" : cvvTF.text ?? "" , "lang" : "en","api_key":APIKEY,"card_id":cardIdStr ?? ""]
        }
    
       
        
        print(params)
        
        Alamofire.request(addOreditCards, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
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

}


extension EditCardDetailsVC : UITextFieldDelegate {
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.cardNumberTF{
//        let maxLength = 16
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
            
//            var strText: String? = textField.text
//            if strText == nil {
//                strText = ""
//            }
//
//            strText = strText?.replacingOccurrences(of: " ", with: "")
//            if strText!.characters.count > 1 && strText!.characters.count % 4 == 0 && string != "" {
//                print(strText?.characters.count)
//                //&& strText!.characters.count % 2 == 0
//                textField.text = "\(textField.text!) \(string)"
//                return false
//            }
//            else{
//                return true
//
//            }
            
            
            if range.location == 19 {
                return false
            }
            
            if range.length == 1 {
                if (range.location == 5 || range.location == 10 || range.location == 15) {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if (range.location == 4 || range.location == 9 || range.location == 14) {
                textField.text = String(format: "%@ ", textField.text ?? "")
            }
            
        }
        else if textField == self.cvvTF{
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == cardExpiryTF {
            if range.location == 5 {
                return false
            }
            
            if range.length == 1 {
                if (range.location == 3) {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                    
                    //let newStr = str[..<index]
                   // textField.text = [Int](String(text[index...]))
                        //text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if (range.location == 2) {
                textField.text = String(format: "%@/", textField.text ?? "")
            }
            
           /* var strText: String? = textField.text
            if strText == nil {
                strText = ""
            }
            strText = strText?.replacingOccurrences(of: "/", with: "")
            if strText!.characters.count == 2 && string != "" {
                print(strText?.characters.count)
                //&& strText!.characters.count % 2 == 0
                textField.text = "\(textField.text!)/\(string)"
                return false
            }
            else{
                
                let maxLength = 5
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }*/
    
        }
        return true
    }

}


