//
//  RatingViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class RatingViewController: UIViewController,UITextViewDelegate{
    
    @IBOutlet var complimentTextView: UITextView!
    
    @IBOutlet weak var submitSt: UIButton!
    @IBOutlet weak var giveusComplimentSt: UILabel!
    @IBOutlet weak var ratingSt: UILabel!
    @IBOutlet weak var orderNoSt: UILabel!
    @IBOutlet weak var rate1Btn: UIButton!
    
    @IBOutlet weak var rate5Btn: UIButton!
    @IBOutlet weak var rate4Btn: UIButton!
    @IBOutlet weak var rate3Btn: UIButton!
    @IBOutlet weak var rate2Btn: UIButton!
    @IBOutlet weak var providerNameLbl: UILabel!
    
    @IBOutlet weak var orderIdLbl: UILabel!
    
    @IBOutlet weak var providerImg: UIImageView!
    
    
    var orderIdForRating = ""
    var ownerIdOfOrder = ""
    var givenRating = "3"
    var providerName = ""
    var providerImgStr = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        complimentTextView.delegate = self
        
        self.title = "Ratings"
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        self.complimentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.complimentTextView.layer.borderWidth = 1.0
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func showLeftView(sender: AnyObject?) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        rate1Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate2Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate3Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate4Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate5Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        
        self.providerNameLbl.text = providerName
        self.orderIdLbl.text = orderIdForRating
        
        providerImg.sd_setImage(with: URL(string:providerImgStr), placeholderImage:UIImage(named:"Group 3873"))
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.complimentTextView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if complimentTextView.text == ""
        {
            self.complimentTextView.text = "Write a thank you note"
        }
        
    }
    
    
    @IBAction func rate1BtnTap(_ sender: Any)
    {
        self.givenRating = "1"
        rate1Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate2Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate3Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate4Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate5Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        
    }
    
    
    @IBAction func rate2BtnTap(_ sender: Any)
    {
        self.givenRating = "2"
        rate1Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate2Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate3Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate4Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate5Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
    }
    
    
    @IBAction func rate3BtnTap(_ sender: Any)
    {
        self.givenRating = "3"
        rate1Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate2Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate3Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate4Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
        rate5Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
    }
    
    
    @IBAction func rate4BtnTap(_ sender: Any)
    {
        self.givenRating = "4"
        rate1Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate2Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate3Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate4Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate5Btn.setImage(UIImage(named: "Group 538"), for: UIControl.State.normal)
    }
    
    
    @IBAction func rate5BtnTap(_ sender: Any)
    {
        self.givenRating = "5"
        rate1Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate2Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate3Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate4Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
        rate5Btn.setImage(UIImage(named: "Group 537"), for: UIControl.State.normal)
    }
    
    
    func ratingServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/order_rating"
            
            
            //    https://www.volive.in/spsalon/services/order_rating
            //    api_key:2382019
            //    lang:en
            //    owner_id:79
            //    user_id:80
            //    order_id:372
            //    rating:4
            //    rating_comment:Very good service
            
            let userId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
                ["lang":"en","api_key":APIKEY,"owner_id":ownerIdOfOrder,"user_id":userId,"order_id":orderIdForRating,
                 "rating":self.givenRating,"rating_comment":complimentTextView.text ?? ""
            ]
            
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
                        
                        print(responseData)
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if status == 1
                        {
                            self.showToastForAlert(message: message)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1)
                            {
                                
                                let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHomeViewController1") as! UserHomeViewController
                                self.navigationController?.pushViewController(details, animated: true)
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
    
    
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if complimentTextView.text != ""
        {
            if complimentTextView.text != "Write a thank you note"
            {
                self.ratingServiceCall()
            }
            else
            {
                showToastForAlert(message: "Please enter complimentary note")
            }
        }
        else
        {
            showToastForAlert(message: "Please enter complimentary note")
        }
        
    }
    
    
}
