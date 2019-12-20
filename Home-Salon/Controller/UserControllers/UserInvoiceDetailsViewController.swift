//
//  UserInvoiceDetailsViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class UserInvoiceDetailsViewController: UIViewController,UITextFieldDelegate {

    
    
    
    @IBOutlet weak var paymentOptionBtn: UIButton!
    
    @IBOutlet weak var totalAmtSt: UILabel!
    @IBOutlet weak var subTotalSt: UILabel!
    @IBOutlet weak var detailsSt: UILabel!
    @IBOutlet weak var discountCoupnSt: UILabel!
    @IBOutlet weak var serviceDetailsSt: UILabel!
    @IBOutlet weak var dateSt: UILabel!
    @IBOutlet weak var invoiceNoSt: UILabel!
    @IBOutlet weak var customerNameSt: UILabel!
    @IBOutlet weak var orderNoSt: UILabel!
    @IBOutlet weak var ht2: NSLayoutConstraint!
    @IBOutlet weak var ht1: NSLayoutConstraint!
    @IBOutlet weak var colonsCoupon: UILabel!
    @IBOutlet weak var special10St: UILabel!
    @IBOutlet weak var couponBackView: UIView!
    @IBOutlet weak var couponSt: UILabel!
    @IBOutlet weak var couponTFViewHt: NSLayoutConstraint!
    @IBOutlet var couponCodeTF: UITextField!
    @IBOutlet weak var invoiceTVHt: NSLayoutConstraint!
    @IBOutlet weak var invoiceTV: UITableView!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var invoiceNoLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var coponPriceLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var payBtn: UIButton!
    var checkString : String?
    var invoiceId = ""
    var orderId = ""
    var paymentStatus = ""
  
    //
     var customerName = ""
     var orderNo = ""
     var invoiceNumber = ""
    var bookingDate = ""
    var servicaNameArr = [String]()
    var servicePriceArr = [String]()
    var subTotal = ""
    var amount = ""
    var totalAmount = ""
    
    var discountAmt1 = ""
    //promo code
    var discountAmt = 0
    var discountType = ""
    var discountLblAmt = ""
    var paidAmt = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.couponCodeTF.layer.borderColor = UIColor.lightGray.cgColor
        self.couponCodeTF.layer.borderWidth = 1.0
        self.couponCodeTF.delegate = self
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        invoiceDetailsServiceCall()
        
    }
    
   
    @IBAction func paymentOptionBtnAction(_ sender: Any) {
        
        let payment = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        payment.amount = self.amount
        payment.paidamount = self.totalAmount
        payment.payOrderId = self.orderId
        payment.invoiceId = self.invoiceId
        payment.discount = String(self.discountAmt)
        payment.appliedPromoCode = self.couponCodeTF.text ?? ""
       
        self.navigationController?.pushViewController(payment, animated: true)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if couponCodeTF.text == ""
//        {
//            self.coponPriceLbl.text = "0"
//            self.totalAmtLbl.text = self.amount
//        }
//    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
       // if self.checkString == "Side"{
            
            let request = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
             request.checkString = "Side"
            self.navigationController?.pushViewController(request, animated: true)
            
            //present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
//        }
//        else{
//
//            self.navigationController?.popViewController(animated: true)
//        }
       
    }
    
    @IBAction func applyBtnTap(_ sender: Any)
    {
        promoCode()
        
    }
    
    //promo code service call
    
    func promoCode()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let invoiceUrl = "\(base_path)services/check_promocode"
            
//            https://www.volive.in/spsalon/services/check_promocode
//            Check promocode valid or not (POST method)
//
//            api_key:2382019
//            lang:en
//            owner_id
//            promocode
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":userId,"promocode":self.couponCodeTF.text ?? ""
               ]
            
        
            print(parameters)
            
            Alamofire.request(invoiceUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    
                    if status == 1
                    {
                        if let response1 = responseData["promocode"] as? [String:Any]
                        {
                            if let discount = response1["discount"] as? String
                            {
                                self.discountAmt = Int(discount) ?? 0
                            }
                            
                            if let discount_type = response1["discount_type"] as? String
                            {
                                self.discountType = discount_type
                            }
                           
                        }
                        
                        if self.discountType == "price"
                        {
                    
                            if let actualPrice = Int(self.subTotal)
                            {
                                
                                self.totalAmount = String(actualPrice - self.discountAmt)
                                
                            }
                            
                        }
                        
                        else if self.discountType == "percentage"
                        {
                            
                            if let actualPrice = Int(self.subTotal)
                            {
                                let amount = (actualPrice*self.discountAmt)/100
                                self.totalAmount = String(actualPrice - amount)
                                
                                if let total = Int(self.totalAmount)
                                {
                                    self.discountAmt = actualPrice - total
                                }
                            }
                            
                        }
                        else
                        {
                            self.totalAmount = self.amount
                        }
                        
                        
                        DispatchQueue.main.async
                        {
                            self.showToastForAlert(message: message)
                            self.coponPriceLbl.text =  String(self.discountAmt)
                            self.totalAmtLbl.text = String(self.totalAmount) + " " + "SAR"
                            
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        
                        self.discountAmt = 0
                        
                        if self.discountType == "price"
                        {
                            
                            if let actualPrice = Int(self.subTotal)
                            {
                                
                                self.totalAmount = String(actualPrice - self.discountAmt)
                                
                            }
                            
                        }
                        else if self.discountType == "percentage"
                        {
                            
                            if let actualPrice = Int(self.subTotal)
                            {
                                let amount = (actualPrice*self.discountAmt)/100
                                self.totalAmount = String(actualPrice - amount)
                                 if let total = Int(self.totalAmount)
                                 {
                                   self.discountAmt = actualPrice - total
                                }
                            }
                            
                        }
                        else
                        {
                            self.totalAmount = self.amount
                        }
                        
                        DispatchQueue.main.async {
                            self.showToastForAlert(message: message)
                            self.coponPriceLbl.text =  String(self.discountAmt)
                            self.totalAmtLbl.text = String(self.totalAmount) + " " + "SAR"
                        }
                        
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
    
    
    // invoice details service call
    
    func invoiceDetailsServiceCall()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let invoiceUrl = "\(base_path)services/invoice_details"
            
//            https://www.volive.in/spsalon/services/invoice_details
//            api_key:2382019
//            lang:en
//            invoice_id:HS5DA9BBB5DE82621
//            order_id:94
//            user_id:21
            
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":userId,"invoice_id":invoiceId,
                "order_id":orderId]
                
            
            
            print(parameters)
            
            Alamofire.request(invoiceUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    self.servicaNameArr.removeAll()
                    self.servicePriceArr.removeAll()
                    print(responseData)
                    
                    if status == 1
                    {
                        if let response1 = responseData["invoice_details"] as? [String:Any]
                        {
                                if let name = response1["name"] as? String
                                {
                                    self.customerName = name
                                 }
                            
                                if let order_no = response1["order_id"] as? String
                                {
                                    self.orderNo = order_no
                                }
                              if let invoiceNumber = response1["invoice_id"] as? String
                             {
                                self.invoiceNumber = invoiceNumber
                             }
                            
                             if let bookingDate = response1["order_date"] as? String
                             {
                                self.bookingDate = bookingDate
                             }
                            
                            if let subTotal = response1["subtotal"] as? String
                            {
                                self.subTotal = subTotal
                            }
                            
                            if let totalAmount = response1["total_amount"] as? String
                            {
                                self.totalAmount = totalAmount
                            }
                            if let amount = response1["amount"] as? String
                            {
                                self.amount = amount
                            }
                            if let payment_status = response1["payment_status"] as? String
                            {
                                self.paymentStatus = payment_status
                            }
                            if let discount_amount = response1["discount_amount"] as? String
                            {
                                self.discountLblAmt = discount_amount
                            }
                            if let paid_amount = response1["paid_amount"] as? String
                            {
                                self.paidAmt = paid_amount
                            }
                            
                          
                            
                            if let response2 = response1["service_details"] as? [[String:Any]]
                            {
                            
                             for i in 0..<response2.count
                             {
                                if let service_name = response2[i]["service_name"] as? String
                                {
                                    self.servicaNameArr.append(service_name)

                                }
                                if let price = response2[i]["price"] as? String
                                {
                                    self.servicePriceArr.append(price)
                                    
                                }
                                
                              }
                            }
                        }
                        
                        DispatchQueue.main.async
                        {
                            self.orderNoLbl.text = self.orderNo
                            self.customerNameLbl.text = self.customerName
                            self.invoiceNoLbl.text = self.invoiceNumber
                            self.dateLbl.text = self.bookingDate
                            self.totalAmtLbl.text = self.totalAmount + " " + "SAR"
                            self.subTotalLbl.text = self.subTotal + " " + "SAR"
                            self.invoiceTV.reloadData()
                            self.coponPriceLbl.text = "0"
                            if self.paymentStatus == "1"
                            {
                                if self.discountLblAmt != "0"
                                {
                                    self.coponPriceLbl.text = self.discountLblAmt
                                   
                                    
                                    self.colonsCoupon.isHidden = false
                                   
                                    self.couponSt.isHidden = false
                                    self.totalAmtLbl.text = self.paidAmt + " " + "SAR"
                                }
                                else
                                {
                                    self.coponPriceLbl.isHidden = true
                                   
                                    self.colonsCoupon.isHidden = true
                                    
                                    self.couponSt.isHidden = true
                                    self.totalAmtLbl.text = self.subTotal + " " + "SAR"
                                    
                                }
                                
                                self.applyBtn.isHidden = true
                                self.couponTFViewHt.constant = 0
                                self.payBtn.isHidden = true
                                self.couponBackView.isHidden = true
                                
                            }
                            else
                            {
                                self.applyBtn.isHidden = false
                                self.couponTFViewHt.constant = 100
                                self.payBtn.isHidden = false
                                self.coponPriceLbl.isHidden = false
                                self.couponSt.isHidden = false
                                self.couponBackView.isHidden = false
                                
                              
                                self.colonsCoupon.isHidden = false
                               
                                self.totalAmtLbl.text = String(self.subTotal) + " " + "SAR"
                                
                            }
//                            if let actualPrice = Int(self.subTotal)
//                            {
//
//                                self.totalAmount = String(actualPrice - self.discountAmt)
//
//                            }
                            self.totalAmount = self.subTotal
                            
                            self.invoiceTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                            
                            self.view.layoutIfNeeded()
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        invoiceTV.layer.removeAllAnimations()
        invoiceTVHt.constant = invoiceTV.contentSize.height
        
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    
}

extension UserInvoiceDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicaNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath) as! UserOrdersTableViewCell
        
       
        cell.serviceNameLbl.text = servicaNameArr[indexPath.row]
        cell.servicePriceLbl.text = servicePriceArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    
    
}

