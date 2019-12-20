//
//  PaymentViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class PaymentViewController: UIViewController {

    @IBOutlet weak var payWithCardBtn: UIButton!
    
    
    @IBOutlet weak var payNowBtn: UIButton!
    @IBOutlet weak var secureCreditCardSt: UIButton!
    @IBOutlet weak var cvvSt: UILabel!
    @IBOutlet weak var cardExpSt: UILabel!
    @IBOutlet weak var nameOnCardSt: UILabel!
    @IBOutlet weak var cardNumberSt: UILabel!
    @IBOutlet weak var cardTypeSt: UILabel!
    @IBOutlet weak var entercardSt: UILabel!
    @IBOutlet weak var payByCahBtn: UIButton!
    
    @IBOutlet var cardTypeBtn: UIButton!
    @IBOutlet var nameOncardTF: UITextField!
    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var cardExpiryTF: UITextField!
    @IBOutlet var cvvTF: UITextField!
    @IBOutlet weak var amountOfThaeService: UILabel!
    @IBOutlet weak var cardViewHt: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
  
    var payString = "2"
    var amount = ""
    var payOrderId = ""
    var appliedPromoCode = ""
    var invoiceId = ""
    var discount = ""
    var paidamount = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCustomDesign()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.amountOfThaeService.text = paidamount + " " + "SAR"
        
        if payString == "2"
        {
            cardBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
            cashBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        }
        
        
    }
    
    func loadCustomDesign(){
        self.cardTypeBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.cardTypeBtn.layer.borderWidth = 1.0
        self.nameOncardTF.layer.borderColor = UIColor.lightGray.cgColor
        self.nameOncardTF.layer.borderWidth = 1.0
        self.cardNumberTF.layer.borderColor = UIColor.lightGray.cgColor
        self.cardNumberTF.layer.borderWidth = 1.0
        self.cardExpiryTF.layer.borderColor = UIColor.lightGray.cgColor
        self.cardExpiryTF.layer.borderWidth = 1.0
        self.cvvTF.layer.borderColor = UIColor.lightGray.cgColor
        self.cvvTF.layer.borderWidth = 1.0
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payNowBtnAction(_ sender: Any) {
        
        paymentServiceCall()
    }
    
    
    // paymentService
    
    func paymentServiceCall()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let payUrl = "\(base_path)services/payment"
            
            //    https://www.volive.in/spsalon/services/payment
            //    Save payment details (POST method)
            //
            //    api_key:2382019
            //    lang:en
            //    order_id
            //    invoice_id
            //    amount
            //    paid_amount
            //    return_amount (send 0 if empty)
            //    tax_amount
            //    discount_amount (send 0 if not available)
            //    payment_method (1->cash, 2->card)
            //    promocode (optional)
            
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "invoice_id":invoiceId,
                "order_id":payOrderId,"amount":amount,"paid_amount":paidamount,"return_amount":"0","tax_amount":"0",
                "discount_amount":discount,"payment_method":payString,"promocode":appliedPromoCode
            ]
            
            print(parameters)
            
            Alamofire.request(payUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
        
                    if status == 1
                    {
                        
                        DispatchQueue.main.async
                        {
                           self.showToastForAlert(message: message)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
                            {
                                
                        let success = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                        success.orderId = self.payOrderId
                        self.navigationController?.pushViewController(success, animated: true)
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
    
    @IBAction func cardBtnTap(_ sender: Any)
    {
        payString = "2"
        cardBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        cashBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        cardView.isHidden = false
        cardViewHt.constant = 440
    }
    
    
    @IBAction func cashBtnTap(_ sender: Any) {
        
        payString = "1"
        cashBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        cardBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        cardView.isHidden = true
        cardViewHt.constant = 0
    }
    
    
}
