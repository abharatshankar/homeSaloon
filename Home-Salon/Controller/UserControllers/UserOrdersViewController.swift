//
//  UserOrdersViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class UserOrdersViewController: UIViewController {
   
    var checkString : String?
    
    var shopNameArr = [String]()
    var requestsOrderIdArr = [String]()
    var requestsDateArr = [String]()
    var requestStatusArr = [String]()
    var requestStatusnameArr = [String]()
    var displayPicArr = [String]()
    var ownerIdArr = [String]()
    var ratingArr = [String]()
    
    
    @IBOutlet weak var orderTv: UITableView!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = languageChangeString(a_str: "Orders")
        self.orderTv.tableFooterView = UIView()
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
        // Do any additional setup after loading the view.
    
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(orderAccept(_:)), name: NSNotification.Name(rawValue: "order_complete"), object: nil)
  }

  @objc func orderAccept(_ notification: Notification)
  {
    
    self.checkString = ""
    requestListServiceCall()
    
  }
    
    @objc func showLeftView(sender: AnyObject?) {
        if  self.checkString == "Side" {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
   
    @IBAction func giveRatingBtnTap(_ sender: UIButton) {
    
        let rating = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        rating.orderIdForRating = requestsOrderIdArr[sender.tag]
        rating.ownerIdOfOrder = ownerIdArr[sender.tag]
        rating.providerName = shopNameArr[sender.tag]
        rating.providerImgStr = displayPicArr[sender.tag]
        
        self.navigationController?.pushViewController(rating, animated: true)
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId == ""
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
              self.logInAlert()
            
            }
        }
        else
        {
        
           requestListServiceCall()
            
        }
    }

    
    func requestListServiceCall()
    {
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let requestsUrl = "\(base_path)services/user_order_list"
            
            //    https://www.volive.in/spsalon/services/user_order_list
            //    user requested orders(now) (POST method)
            //
            //    Note- we are calling same api for reqested order list and order list
            //
            //    api_key:2382019
            //    lang:en
            //    user_id:15
            //    list_type:(1-request orders 2 -order list(which has been completed))
            
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":userId,"list_type":"2"
                
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
                    self.ownerIdArr.removeAll()
                    self.ratingArr.removeAll()
                    
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
                                if let display_pic = response1[i]["display_pic"] as? String
                                {
                                    self.displayPicArr.append(base_path+display_pic)
                                }
                                if let order_status_name = response1[i]["order_status_name"] as? String
                                {
                                    self.requestStatusnameArr.append(order_status_name)
                                }
                                if let owner_id = response1[i]["owner_id"] as? String
                                {
                                    self.ownerIdArr.append(owner_id)
                                }
                                if let rating = response1[i]["rating"] as? String
                                {
                                    self.ratingArr.append(rating)
                                }
                                
                                
                                
                                
                                // 1 accepted 2 rejected 0 no one respond
                                
                            }
                            
                            DispatchQueue.main.async {
                                self.orderTv.reloadData()
                            }
                            
                            
                        }
                        
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message)
                        self.orderTv.reloadData()
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


    @IBAction func viewDetailsBtnTap(_ sender: UIButton) {
    
    
        let details = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderViewDetailsViewController") as! OrderViewDetailsViewController
        details.orderId = requestsOrderIdArr[sender.tag]
        details.variationCheckString = "orders"
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    
}



extension UserOrdersViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsOrderIdArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrdersTableViewCell", for: indexPath) as! UserOrdersTableViewCell
       
        cell.orderNoSt.text = languageChangeString(a_str: "Order NO")
        cell.dateTimeSt.text = languageChangeString(a_str: "Date & Time")
        cell.orderStatusSt.text = languageChangeString(a_str: "Order Status")
        
        cell.viewDetailsBtn.setTitle(languageChangeString(a_str: "View Details"), for: UIControl.State.normal)
        cell.ratingBtn.setTitle(languageChangeString(a_str: "GIVE RATING"), for: UIControl.State.normal)
        
        cell.orderIdLbl.text = requestsOrderIdArr[indexPath.row]
        cell.dateTimeLbl.text = requestsDateArr[indexPath.row]
        cell.providerNameLbl.text = shopNameArr[indexPath.row]
        cell.statusValueLabel.text = requestStatusnameArr[indexPath.row]
        cell.viewDetailsBtn.tag = indexPath.row
        cell.ratingBtn.tag = indexPath.row
        
        cell.salonImageView.sd_setImage(with: URL(string:displayPicArr[indexPath.row]), placeholderImage:UIImage(named:"Group 3873"))
       
        if requestStatusnameArr[indexPath.row] == "Completed"
        {
            cell.statusImageView.image = UIImage(named: "Completed")
        }
        else
        {
            cell.statusImageView.image = UIImage(named: "pending")
            
        }
        
        if ratingArr[indexPath.row] == "0"
        {
            cell.ratingBtn.isHidden = false
        }
        else
        {
            cell.ratingBtn.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}

extension UIViewController
{
    func logInAlert()
    {
        let refreshAlert = UIAlertController(title: "Guest Login Alert!", message: "Dear user, you are logged in as a guest please login or signup to get all the features of App", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Go to Login", style: .default, handler: { (action: UIAlertAction!) in
            let LoginVC1 = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            UserDefaults.standard.set("user", forKey: "type")
            LoginVC1.userTypeString = "user"
            let navi = UINavigationController.init(rootViewController: LoginVC1)
            self.navigationController?.present(navi, animated: true, completion: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No Wait", style: .default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
}
