//
//  RejectVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 30/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire


class RejectVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reasonReqSt: UILabel!
    @IBOutlet weak var reasonTF: UITextField!
    
    @IBOutlet weak var reasonforRejectSt: UILabel!
    var orderIdToReject = ""
    var selectedReason = ""
    var selectedReasonId = ""
    var selectedReqId = ""
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    var textfieldCheckValue : Int!
    
    
    var reasons = [String]()
    var reasonIds = [String]()
    
   let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        reasonTF.delegate = self
        
        self.reasonReqSt.text = languageChangeString(a_str: "REJECT REQUEST")
        self.reasonforRejectSt.text = languageChangeString(a_str: "Reasons for Rejection")
        self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
       
        
        if language == "ar"
        {
           self.reasonTF.textAlignment = .right
        }
        else
        {
            self.reasonTF.textAlignment = .left
        }
     // Do any additional setup after loading the view.
    }
    

    @IBAction func submitBtnAction(_ sender: Any) {
      
        if selectedReasonId != ""
        {
            acceptOrRejectCall(id:selectedReasonId)
        }
        else
        {
            showToastForAlert(message: languageChangeString(a_str:"Please select reason to reject the request")!)
        }
    }
    

    @IBAction func closeBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.4151776433, green: 0.4554072618, blue: 0.5596991777, alpha: 1)
        
        //  toolBar.backgroundColor = UIColor.blue
        
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func donePickerView(){
        
        self.selectedReason = reasons[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
        self.reasonTF.text = self.selectedReason
        
        selectedReasonId = reasonIds[(pickerView?.selectedRow(inComponent: 0)) ?? 0]
        if selectedReason.count > 0{
            
            self.reasonTF.text = self.selectedReason
            
        }else{
            self.reasonTF.text = reasons[0]
        }
        
        
        self.view.endEditing(true)
        reasonTF.resignFirstResponder()
        
        
    }
    
    @objc func cancelPickerView(){
        
            if (reasonTF.text?.count)! > 0 {
                self.view.endEditing(true)
                reasonTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                reasonTF.text = ""
                reasonTF.resignFirstResponder()
            }
        
        reasonTF.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == self.reasonTF)
        {
           
            self.pickUp(self.reasonTF)
        }
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if (textField == self.reasonTF)
        {
            return true
        }
        
        return true
    }
    
    
    
    
    //accept or reject request post call
    
    func acceptOrRejectCall(id:String)
    {
        
        
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/accept_request"
            //"https://www.volive.in/spsalon/services/accept_request"
            
            //        https://www.volive.in/spsalon/services/accept_request
            //        api_key:2382019
            //        lang:en
            //        owner_id
            //        order_id
            //        reason_id (for reject)
            //request_id
            
            let ownerId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
                ["lang":"en","api_key":APIKEY,"owner_id":ownerId,"order_id":orderIdToReject,"reason_id":id,"request_id":selectedReqId]
            
            
            print(parameters)
            
            
            Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
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
                            
                             NotificationCenter.default.post(name: NSNotification.Name("reject"), object: nil)
                           
                            DispatchQueue.main.async {
                                
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                            
                            //self.showToastForAlert(message: message)
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
            self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
        
    }
    
    
    
}

extension RejectVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        return reasonIds.count
     }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        
        return reasons[row]
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
            
        self.reasonTF.text =  reasons[row]
        self.selectedReason = reasons[row]
        selectedReasonId = reasonIds[row]
    }
    
}

