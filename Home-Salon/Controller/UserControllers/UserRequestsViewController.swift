//
//  UserRequestsViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class UserRequestsViewController: UIViewController {

    var checkString : String?
    
    var shopNameArr = [String]()
    var requestsOrderIdArr = [String]()
    var requestsDateArr = [String]()
    var requestStatusArr = [String]()
    var requestStatusnameArr = [String]()
    var displayPicArr = [String]()
    var requestInvoiceArr = [String]()
    var ordercancelArr = [String]()
    
    @IBOutlet weak var requestTV: UITableView!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.requestTV.tableFooterView = UIView()
        
        self.requestTV.estimatedRowHeight = 30
        self.requestTV.rowHeight = UITableView.automaticDimension
        
        self.title = languageChangeString(a_str:"Requests")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
//        let btnLeftMenu: UIButton = UIButton()
//        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControl.State())
//        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
//        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
//        let barButton = UIBarButtonItem(customView: btnLeftMenu)
//        self.navigationItem.leftBarButtonItem = barButton
      // navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)

        
        NotificationCenter.default.addObserver(self, selector: #selector(orderAccept(_:)), name: NSNotification.Name(rawValue: "messageSent"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orderAccept1(_:)), name: NSNotification.Name(rawValue: "order_start"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orderCancel(_:)), name: NSNotification.Name(rawValue: "userCancel"), object: nil)
        
    }
    
    
    @objc func orderAccept1(_ notification: Notification)
    {
         self.checkString = "Side"
         userRequestData()
        
    }
    
    
    @objc func orderAccept(_ notification: Notification)
    {
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId != ""
        {
             userRequestData()
        
        }
        
    }

    
    @objc func orderCancel(_ notification: Notification)
    {
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId != ""
        {
            self.checkString = "Side"
            userRequestData()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId == ""
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              
                self.logInAlert()
            }
        }
        else
        {
        
           userRequestData()
        }
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        if self.checkString == "Side"{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
        else{
            
        self.navigationController?.popViewController(animated: true)
        }
        
    }
    

    
    @IBAction func viewInvoiceBtnTap(_ sender: UIButton) {
    
        let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceDetailsViewController") as! UserInvoiceDetailsViewController
        details.invoiceId = requestInvoiceArr[sender.tag]
        details.orderId = requestsOrderIdArr[sender.tag]
        self.navigationController?.pushViewController(details, animated: true)
    }
    
  
    @IBAction func viewDetailsBtnTap(_ sender: UIButton) {
    
    let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewDetailsViewController") as! OrderViewDetailsViewController
        details.orderId = self.requestsOrderIdArr[sender.tag]
        details.invoiceId = self.requestInvoiceArr[sender.tag]
        details.variationCheckString = "requests"
        details.orderStatus = requestStatusArr[sender.tag]
        
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    
    func userRequestData()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let requestsUrl = "\(base_path)services/user_order_list"
            
            //        https://www.volive.in/spsalon/services/user_order_list
            //        user requested orders(now) (POST method)
            //
            //        api_key:2382019
            //        lang:en
            //        user_id:15
            
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
           
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":userId,
                "list_type":"1"
            ]
            
            print(parameters)
            
            Alamofire.request(requestsUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    self.shopNameArr.removeAll()
                    self.requestStatusArr.removeAll()
                    self.requestsDateArr.removeAll()
                    self.requestsOrderIdArr.removeAll()
                    self.requestStatusnameArr.removeAll()
                    self.displayPicArr.removeAll()
                    self.requestInvoiceArr.removeAll()
                    self.ordercancelArr.removeAll()
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if status == 1
                    {
                        if let response1 = responseData["order"] as? [[String:Any]]
                        {
                            
                            for i in 0..<response1.count
                            {
                                if let name = response1[i]["name"] as? String
                                {
                                    self.shopNameArr.append(name)
                                    
                                }
                                if let order_no = response1[i]["order_no"] as? String
                                {
                                    self.requestsOrderIdArr.append(order_no)
                                }
                                if let date = response1[i]["date"] as? String
                                {
                                    self.requestsDateArr.append(date)
                                    
                                }
                                if let order_status = response1[i]["order_status"] as? String
                                {
                                    self.requestStatusArr.append(order_status)
                                }
                                if let order_status_name = response1[i]["order_status_name"] as? String
                                {
                                    self.requestStatusnameArr.append(order_status_name)
                                }
                                if let display_pic = response1[i]["display_pic"] as? String
                                {
                                    self.displayPicArr.append(base_path+display_pic)
                                }
                                if let invoice_id = response1[i]["invoice_id"] as? String
                                {
                                    self.requestInvoiceArr.append(invoice_id)
                                }
                                
                                if let order_cancel = response1[i]["order_cancel"] as? String
                                {
                                    self.ordercancelArr.append(order_cancel)
                                }
                                
                                
                                // 1 accepted 2 rejected 0 no one respond
                                
                            }
                            
                           // print(self.requestStatusArr)
                            DispatchQueue.main.async {
                                self.requestTV.reloadData()
                            }
                            
                            
                        }
                        
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        self.requestTV.reloadData()
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

extension UserRequestsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsOrderIdArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserRequestsTableViewCell", for: indexPath) as! UserRequestsTableViewCell

        cell.orderNoSt.text = languageChangeString(a_str: "Order NO")
        cell.dateTimeSt.text = languageChangeString(a_str: "Date & Time")
        cell.spStatusSt.text = languageChangeString(a_str: "Order Status")
        cell.viewDetailsBtn.setTitle(languageChangeString(a_str: "View Details"), for: UIControl.State.normal)
        cell.viewInvoiceBtn.setTitle(languageChangeString(a_str: "VIEW INVOICE"), for: UIControl.State.normal)
        
        cell.salonImageView.sd_setImage(with: URL(string:displayPicArr[indexPath.row]), placeholderImage:UIImage(named:"Group 3873"))
        cell.orderNoLbl.text = requestsOrderIdArr[indexPath.row]
        cell.dateLbl.text = requestsDateArr[indexPath.row]
        cell.requestShopName.text = shopNameArr[indexPath.row]
        if ordercancelArr[indexPath.row] == "1"
        {
             cell.statusValueLabel.text = "Cancelled"
        }
        else
        {
            cell.statusValueLabel.text = requestStatusnameArr[indexPath.row]
        }
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewInvoiceBtn.tag = indexPath.row
        

        if requestStatusArr[indexPath.row] == "0" || requestStatusArr[indexPath.row] == "2"
        {

            cell.viewInvoiceBtn.isHidden = true
           
        }
        else
        {
            cell.viewInvoiceBtn.isHidden = false
          
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    
    
}
