//
//  PendingVC.swift
//  Home-Salon
//
//  Created by harshitha on 16/10/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu

class PendingVC: UIViewController {
    
    var checkStr1 : String?
    var pendingNameArr = [String]()
    var pendingImgArr = [String]()
    var pendingOrderIdArr = [String]()
    var pendingDateArr = [String]()
    var pendingTimeArr = [String]()
    var paymentStatusArr = [String]()
    var orderStatusArr = [String]()
    
    
    @IBOutlet weak var pendingTV: UITableView!
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pendingTV.tableFooterView = UIView()
        self.navigationItem.title = languageChangeString(a_str:"Pending")
        
        NotificationCenter.default.addObserver(self, selector: #selector(orderPay(_:)), name: NSNotification.Name(rawValue: "order_payment"), object: nil)
        
        
    }
    
    
    @objc func orderPay(_ notification: Notification)
    {
        
        self.checkStr1 = ""
        pendingList()
        
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
       
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        pendingList()
        
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        
        if checkStr1 == "req"{
            self.navigationController?.popViewController(animated: true)
        }else{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
            
        }
    }
    
    
    // pendind List Service call

    func pendingList()
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
            //list_type
            //1-requested 2-pending 3-completed 4-schedule


            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""

            //let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "owner_id":userId,
                "list_type":"2"
            ]

            print(parameters)

            Alamofire.request(requestsUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)

                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String

                    self.pendingNameArr.removeAll()
                    self.pendingOrderIdArr.removeAll()
                    self.pendingImgArr.removeAll()
                    self.pendingDateArr.removeAll()
                    self.pendingTimeArr.removeAll()
                    self.paymentStatusArr.removeAll()
                    self.orderStatusArr.removeAll()
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if status == 1
                    {
                        if let response1 = responseData["order"] as? [[String:Any]]
                        {

                            for i in 0..<response1.count
                            {
                                if let name = response1[i]["name"] as? String
                                {
                                    self.pendingNameArr.append(name)

                                }
                                if let order_id = response1[i]["order_id"] as? String
                                {
                                    self.pendingOrderIdArr.append(order_id)
                                }
                                if let now_date = response1[i]["now_date"] as? String
                                {
                                    self.pendingDateArr.append(now_date)

                                }
                                if let now_time = response1[i]["now_time"] as? String
                                {
                                    self.pendingTimeArr.append(now_time)
                                    
                                }
                                if let display_pic = response1[i]["display_pic"] as? String
                                {
                                    self.pendingImgArr.append(base_path+display_pic)
                                    
                                }
                                if let payment_status = response1[i]["payment_status"] as? String
                                {
                                    self.paymentStatusArr.append(payment_status)
                                    
                                }
                                if let order_status = response1[i]["order_status"] as? String
                                {
                                    self.orderStatusArr.append(order_status)
                                    
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.pendingTV.reloadData()
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
    
    
    
    @IBAction func starWorkBtnTap(_ sender: UIButton)
    {
        
        let workStartOrderId = pendingOrderIdArr[sender.tag]
        
        if orderStatusArr[sender.tag] == "1"
        {
            startWorkServiceCall(id: workStartOrderId, orderStatus: "6")
        }
        if orderStatusArr[sender.tag] == "6"
        {
            startWorkServiceCall(id: workStartOrderId, orderStatus: "4")
        }
        
    }
    
    
    func startWorkServiceCall(id:String,orderStatus:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            
            let requestUrl = "\(base_path)services/update_order_status"
            
            //        https://www.volive.in/spsalon/services/update_order_status
            
            //        To update order status incase of start and complte work
            //
            //        api_key:2382019
            //        lang:en
            //        owner_id:136
            //        order_id:172
            //        order_status:(6
            
            let ownerId = UserDefaults.standard.object(forKey: "user_id") ?? ""
            
            let parameters: Dictionary<String, Any> =
                ["lang":language,"api_key":APIKEY,"owner_id":ownerId,"order_id":id,"order_status":orderStatus
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
                        
                        
                        
                        if status == 1
                        {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                           
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                
                                if orderStatus == "6"
                                {
                                    self.pendingList()
                                    
                                }
                                else
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                                    vc.checkIntValue = "3"
                                    vc.checkStr = ""
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
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
            self.showToastForAlert(message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
            
        }
    }
    
    
    @IBAction func viewDetailsBtnTap(_ sender: UIButton) {
        
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingDetailsVC") as! PendingDetailsVC
        
         gotoVC.orderIdToSee = pendingOrderIdArr[sender.tag]
        self.navigationController?.pushViewController(gotoVC, animated: true)
        
    }
    
    
    
}

extension PendingVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return pendingOrderIdArr.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "pending") as! OrderTypeListCell
        
        cell.orderIdSt.text = languageChangeString(a_str: "Order ID")
        cell.visitDateTimeSt.text = languageChangeString(a_str: "Visit Date&Times")
        cell.viewDetailsBtn.setTitle(languageChangeString(a_str: "View Details"), for: UIControl.State.normal)
        
        cell.nameLbl.text = pendingNameArr[indexPath.row]
        cell.orderLbl.text = pendingOrderIdArr[indexPath.row]
        if paymentStatusArr[indexPath.row] == "1"
        {
            cell.paymentStatusLabel.text = languageChangeString(a_str:"PAID")
        }
        else
        {
            cell.paymentStatusLabel.text = ""
        }
        if orderStatusArr[indexPath.row] == "6"
        {
            cell.workStartBtn.setTitle(languageChangeString(a_str:"COMPLETE WORK"), for: UIControl.State.normal)
        }
        if orderStatusArr[indexPath.row] == "1"
        {
            cell.workStartBtn.setTitle(languageChangeString(a_str:"START WORKING"), for: UIControl.State.normal)
        }
        cell.dateLbl.text = pendingDateArr[indexPath.row] + " " + pendingTimeArr[indexPath.row]
        cell.viewDetailsBtn.tag = indexPath.row
        cell.workStartBtn.tag = indexPath.row
        cell.workStartBtn.layer.borderColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0).cgColor
        cell.workStartBtn.layer.borderWidth = 1.0
        cell.displayImg.sd_setImage(with: URL(string:pendingImgArr[indexPath.row]), placeholderImage:UIImage(named:"Group 3873"))
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return  185

    }

}
