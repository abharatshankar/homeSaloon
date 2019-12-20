//
//  OrderViewDetailsViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewDetailsViewController: UIViewController {

    
    @IBOutlet weak var orderStatusSt: UILabel!
    @IBOutlet weak var addressSt: UILabel!
    @IBOutlet weak var descripSt: UILabel!
    @IBOutlet weak var costSt: UILabel!
    
    @IBOutlet weak var schDateTimeSt: UILabel!
    
    @IBOutlet weak var serviceTypeSt: UILabel!
    @IBOutlet weak var serviceSt: UILabel!
    @IBOutlet weak var serviceProviderSt: UILabel!
    @IBOutlet weak var orderNoSt: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet var viewInvoiceBtn: UIButton!
    @IBOutlet var orderStatusStackView: UIStackView!
    @IBOutlet weak var orderPersonNameLbl: UILabel!
    
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var scheduleDateLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var servicesListLbl: UILabel!
    @IBOutlet weak var serviceProviderNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
   
    var variationCheckString : String?
    var orderId = ""
    var orderStatus = ""
    var requestUserName = ""
    var orderNo = ""
    var location = ""
    var serviceProviderName = ""
    var services = ""
    var serviceType = ""
    var visitDate = ""
    var visitTime = ""
    var cost = ""
    var desc = ""
    var address = ""
    var userImage = ""
    var invoiceId = ""
    var service = ""
    var cancelOrderStatus = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.title = languageChangeString(a_str:"View Details")
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
       navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)

        self.serviceSt.text = languageChangeString(a_str: "Service")
        self.orderStatusSt.text = languageChangeString(a_str: "Order Status")
        self.orderNoSt.text = String(format: "%@%@", languageChangeString(a_str: "Order NO") ?? ""," : ")
        
         self.serviceProviderSt.text = languageChangeString(a_str: "Service Provider")
        self.serviceTypeSt.text = languageChangeString(a_str: "Service Type")
        self.schDateTimeSt.text = languageChangeString(a_str: "Scheduled Date & Time")
        self.costSt.text = languageChangeString(a_str: "Cost")
        self.addressSt.text = languageChangeString(a_str: "Address")
        self.descripSt.text = languageChangeString(a_str: "Description")
        self.viewInvoiceBtn.setTitle(languageChangeString(a_str: "VIEW INVOICE"), for: UIControl.State.normal)
        self.cancelBtn.setTitle(languageChangeString(a_str: "CANCEL"), for: UIControl.State.normal)
       
        
        
    }
    
   

    @IBAction func backBtnTap(_ sender: Any) {
        

       self.navigationController?.popViewController(animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if self.variationCheckString == "orders"{
            self.viewInvoiceBtn.isHidden = true
            self.orderStatusStackView.isHidden = false
            self.cancelBtn.isHidden = true
        }
        else{
            self.orderStatusStackView.isHidden = true
            self.viewInvoiceBtn.isHidden = false
            
            if orderStatus == "0" || orderStatus == "2"
            {
                self.viewInvoiceBtn.isHidden = true
                self.cancelBtn.isHidden = true
            }
            else
            {
                self.viewInvoiceBtn.isHidden = false
                self.cancelBtn.isHidden = false
            }
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(rejectMethod), name: NSNotification.Name(rawValue: "cancelReq"), object: nil)
        
        orderDetailsServiceCall()
    }
    
    @objc func rejectMethod(){
        
        let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
        details.checkString = "Side"
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    
    
    @IBAction func cancelBtntap(_ sender: Any) {
    
        let RejectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CancelOrderVC") as! CancelOrderVC
        RejectVC.cancelOrderId = orderId
       
        self.present(RejectVC, animated: true, completion: nil)
    
    }
    
    
    func orderDetailsServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let requestsUrl = "\(base_path)services/order_details"
            
//            https://www.volive.in/spsalon/services/order_details
//            Order details to user (POST method)
//
//            api_key:2382019
//            lang:en
//            user_id
//            order_id
            
            
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":userId,
                "order_id":orderId
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
                        if let response1 = responseData["order"] as? [[String:Any]]
                        {
                            
                            if let name = response1[0]["name"] as? String
                            {
                                self.requestUserName = name
                            }
                            if let order_id = response1[0]["order_id"] as? String
                            {
                                self.orderNo = order_id
                            }
//                            if let location = response1[0]["location"] as? String
//                            {
//                                self.location = location
//                            }
                            if let subcategory_name = response1[0]["subcategory_name"] as? String
                            {
                                self.services = subcategory_name
                            }
                            if let now_date = response1[0]["now_date"] as? String
                            {
                                self.visitDate = now_date
                            }
                            if let now_time = response1[0]["now_time"] as? String
                            {
                                self.visitTime = now_time
                            }
                            if let amount = response1[0]["amount"] as? String
                            {
                                self.cost = amount
                            }
                            if let display_pic = response1[0]["display_pic"] as? String
                            {
                                self.userImage = base_path+display_pic
                            }
                            
                            if let address = response1[0]["address"] as? String
                            {
                                self.location = address
                            }
                            if let service_type = response1[0]["service_type"] as? String
                            {
                                self.service = service_type
                            }
                            
                            if let order_cancel = response1[0]["order_cancel"] as? String
                            {
                                self.cancelOrderStatus = order_cancel
                            }
                            
                        }
                        
                        if let response1 = responseData["provider_info"] as? [String:Any]
                        {
                            
                            if let provider_name = response1["provider_name"] as? String
                            {
                                self.serviceProviderName = provider_name
                            }
                            if let address = response1["address"] as? String
                            {
                                self.address = address
                            }
                            if let description = response1["description"] as? String
                            {
                                self.desc = description
                            }
                           
                            
                        }
                        
                        
                        
                        DispatchQueue.main.async {
                            
                            self.orderPersonNameLbl.text = self.requestUserName
                            self.orderNoLbl.text = self.orderNo
                            self.serviceProviderNameLbl.text = self.serviceProviderName
                            self.servicesListLbl.text = self.services
                            self.locationLbl.text = self.location
                            self.scheduleDateLbl.text = self.visitDate + " " + self.visitTime
                            self.costLbl.text = self.cost + " " + "SAR"
                            self.desLbl.text = self.desc
                            self.addressLbl.text = self.location
                            self.orderStatusLbl.text = self.languageChangeString(a_str:"Completed")
                            if self.service == "1"
                            {
                                self.serviceTypeLbl.text = self.languageChangeString(a_str:"HomeService")
                              
                            }
                            if self.service == "2"
                            {
                                self.serviceTypeLbl.text = self.languageChangeString(a_str:"At the Salon")
                                
                            }
                            self.userImg.sd_setImage(with: URL (string: self.userImage), placeholderImage:
                                UIImage(named: "Group 3873"))
                           
                            if self.variationCheckString != "orders" && self.orderStatus == "1"
                            {
                            
                             if self.cancelOrderStatus == "0"
                             {
                                self.cancelBtn.isHidden = false
                             }
                              else
                             {
                                self.cancelBtn.isHidden = true
                              }
                            }
                            else
                            {
                                self.cancelBtn.isHidden = true
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
            showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
        }
    }
    
    
    
    @IBAction func viewInvoiceBtnAction(_ sender: Any) {
        let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceDetailsViewController") as! UserInvoiceDetailsViewController
        details.invoiceId = invoiceId
        details.orderId = orderId
       
        self.navigationController?.pushViewController(details, animated: true)
    }
}
