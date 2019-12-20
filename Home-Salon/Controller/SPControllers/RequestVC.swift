//
//  RequestVC.swift
//  Home-Salon
//
//  Created by harshitha on 27/09/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu

class RequestVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var requestTV: UITableView!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    var checkStr1 : String?
    
    var requesterNameArr = [String]()
    var requesterImgArr = [String]()
    var requesterOrderIdArr = [String]()
    var requesterDateArr = [String]()
    var requesterTimeArr = [String]()
    var requesIdArr = [String]()
    
    override func viewDidLoad() {
    super.viewDidLoad()
      
        requestTV.tableFooterView = UIView()
        
    self.navigationItem.title = languageChangeString(a_str:"Requests")
       
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
    NotificationCenter.default.addObserver(self, selector: #selector(orderAccept(_:)), name: NSNotification.Name(rawValue: "providerRequest"), object: nil)
    }
    
    @objc func orderAccept(_ notification: Notification)
    {
        
            requestdList()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        requestdList()
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if checkStr1 == "req"{
            self.navigationController?.popViewController(animated: true)
        }else{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
            
        }
    }
    
    
 
    @IBAction func viewDetailsBtnTap(_ sender: UIButton) {
    
    let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
     gotoVC.orderIdToSee = requesterOrderIdArr[sender.tag]
     gotoVC.orderReqId = requesIdArr[sender.tag]
        
        self.navigationController?.pushViewController(gotoVC, animated: true)
   
    }
    
    
    func requestdList()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let requestsUrl = "\(base_path)services/provider_requests"
            
            //    https://www.volive.in/spsalon/services/provider_requests
            //    List of requests to provider (POST method)
            //
            //    api_key:2382019
            //    lang:en
            //    owner_id
            
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "owner_id":userId
                
            ]
            
            print(parameters)
            
            Alamofire.request(requestsUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    self.requesterNameArr.removeAll()
                    self.requesterOrderIdArr.removeAll()
                    self.requesterDateArr.removeAll()
                    self.requesIdArr.removeAll()
                    self.requesterImgArr.removeAll()
                    self.requesterTimeArr.removeAll()
                    
            
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if status == 1
                    {
                        if let response1 = responseData["order"] as? [[String:Any]]
                        {
                            
                            for i in 0..<response1.count
                            {
                                if let name = response1[i]["name"] as? String
                                {
                                    self.requesterNameArr.append(name)
                                    
                                }
                                if let order_id = response1[i]["order_id"] as? String
                                {
                                    self.requesterOrderIdArr.append(order_id)
                                }
                                if let now_date = response1[i]["now_date"] as? String
                                {
                                    self.requesterDateArr.append(now_date)
                                    
                                }
                                if let now_time = response1[i]["now_time"] as? String
                                {
                                    self.requesterTimeArr.append(now_time)
                                    
                                }
                                if let request_id = response1[i]["request_id"] as? String
                                {
                                    self.requesIdArr.append(request_id)
                                    
                                }
                                if let display_pic = response1[i]["display_pic"] as? String
                                {
                                    self.requesterImgArr.append(base_path+display_pic)
                                    
                                }
                                
                                
                            }
                            
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return requesterOrderIdArr.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "request") as! OrderTypeListCell
        
         cell.orderIdSt.text = languageChangeString(a_str: "Order ID")
         cell.visitDateTimeSt.text = languageChangeString(a_str: "Visit Date&Times")
         cell.viewDetailsBtn.setTitle(languageChangeString(a_str: "View Details"), for: UIControl.State.normal)
            cell.nameLbl.text = requesterNameArr[indexPath.row]
            cell.orderLbl.text = requesterOrderIdArr[indexPath.row]
            cell.dateLbl.text = "\(requesterDateArr[indexPath.row])" + " " + "\(requesterTimeArr[indexPath.row])"
            cell.viewDetailsBtn.tag = indexPath.row
            cell.displayImg.sd_setImage(with: URL(string:requesterImgArr[indexPath.row]), placeholderImage:UIImage(named:"Group 3873"))
              
           return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  185
        
    }
    
    
    
    
}
