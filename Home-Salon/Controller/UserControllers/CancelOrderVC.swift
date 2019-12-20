//
//  CancelOrderVC.swift
//  Home-Salon
//
//  Created by harshitha on 17/12/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class CancelOrderVC: UIViewController {
    
    var cancelOrderId = ""
    
    @IBOutlet weak var cancelTF: UITextField!
    
    @IBOutlet weak var cancelReqSt: UILabel!
    
    @IBOutlet weak var reasonForOrderCancelSt: UILabel!
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtnTap(_ sender: Any)
    {
        
        if cancelTF.text != ""
        {
            rejectServiceCall()
        }
        else
        {
            showToastForAlert(message: "Please enter reason for cancel the request")
        }
        
    }
    
    
    @IBAction func closeBtnTap(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func rejectServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let requestsUrl = "\(base_path)services/order_cancel"
            
            //    https://www.volive.in/spsalon/services/order_cancel
            
            
            //    api_key:2382019
            //    lang:en
            //    user_id:137
            //    order_id:633
            //    reason:not available this time
            
            
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":userId,
                "order_id":cancelOrderId,"reason":cancelTF.text ?? ""
            ]
            
            print(parameters)
            
            Alamofire.request(requestsUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if status == 1
                    {
                        
                        DispatchQueue.main.async {
                            
                            self.dismiss(animated: true, completion: nil)
                           
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
                            {
                                self.showToastForAlert(message: message)
                                NotificationCenter.default.post(name: NSNotification.Name("cancelReq"), object: nil)
                                
                            }
                            
                            
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
            showToastForAlert(message:"Please ensure you have proper internet connection")
        }
    }
    

   
}
