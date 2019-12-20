//
//  OrderTypeListVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class OrderTypeListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var backBtn: UIBarButtonItem!
    
    @IBOutlet var orderTypeListTableView: UITableView!
    
    var requesterNameArr = [String]()
    var requesterImgArr = [String]()
    var requesterOrderIdArr = [String]()
    var requesterDateArr = [String]()
    var requesterTimeArr = [String]()
    var requesIdArr = [String]()
    var checkIntValue:String?
    var checkStr : String?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        orderTypeListTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orderCancel(_:)), name: NSNotification.Name(rawValue: "ProviderCancel"), object: nil)
    
    }
    
    @objc func orderCancel(_ notification: Notification)
    {
        self.checkIntValue = "5"
        checkStr = "req"
        
        orderListServiceCall()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if checkIntValue == "3"
        {
            
            self.navigationItem.title = languageChangeString(a_str:"Completed")
        }
        else if checkIntValue == "5"
        {
            
            self.navigationItem.title = languageChangeString(a_str:"Reject")
        }
        
         orderListServiceCall()
    }
    
    
    @IBAction func startWorkBtnAction(_ sender: Any) {
        let invoice = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateInvoiceViewController") as! CreateInvoiceViewController
        self.navigationController?.pushViewController(invoice, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
       
        if checkStr == "req"{
            self.navigationController?.popViewController(animated: true)
        }else{
         present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        
        }
    }
    
    
    func orderListServiceCall()
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
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "owner_id":userId,
                "list_type":checkIntValue ?? ""
            ]
            
            print(parameters)
            
            Alamofire.request(requestsUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    self.requesterNameArr.removeAll()
                    self.requesterOrderIdArr.removeAll()
                    self.requesterDateArr.removeAll()
                    self.requesIdArr.removeAll()
                    self.requesterImgArr.removeAll()
                    self.requesterTimeArr.removeAll()
                    
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
                                self.orderTypeListTableView.reloadData()
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
    
    
    
    
    // #MARK:- TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return requesterOrderIdArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTypeListCell") as! OrderTypeListCell
        
        cell.orderIdSt.text = String(format: "%@%@", languageChangeString(a_str: "Order ID") ?? ""," : ")
        
        cell.visitDateTimeSt.text = languageChangeString(a_str: "Visit Date&Times")
        cell.viewDetailsBtn.setTitle(languageChangeString(a_str: "View Details"), for: UIControl.State.normal)
        
        if checkIntValue == "3"
        {
            cell.imgStatus.isHidden = false
            cell.viewDetailsBtn.backgroundColor = UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0)
            cell.nameLbl.text = requesterNameArr[indexPath.row]
            cell.orderLbl.text = requesterOrderIdArr[indexPath.row]
            cell.dateLbl.text = "\(requesterDateArr[indexPath.row])" + " " + "\(requesterTimeArr[indexPath.row])"
           
            cell.viewDetailsBtn.tag = indexPath.row
            cell.displayImg.sd_setImage(with: URL(string:requesterImgArr[indexPath.row]), placeholderImage:UIImage(named:"Group 3873"))
        }
        else if checkIntValue == "5"
        {
            cell.imgStatus.isHidden = true
            cell.nameLbl.text = requesterNameArr[indexPath.row]
            cell.orderLbl.text = requesterOrderIdArr[indexPath.row]
            cell.dateLbl.text = "\(requesterDateArr[indexPath.row])" + " " + "\(requesterTimeArr[indexPath.row])"
            cell.viewDetailsBtn.backgroundColor = UIColor.init(red: 161.0/255.0, green: 144.0/255.0, blue: 129.0/255.0, alpha: 1.0)
           
            cell.viewDetailsBtn.tag = indexPath.row
            cell.displayImg.sd_setImage(with: URL(string:requesterImgArr[indexPath.row]), placeholderImage:UIImage(named:"Group 3873"))
            
        }
         cell.viewDetailsBtn.addTarget(self, action: #selector(self.ViewDetailData(_:)) ,for: .touchUpInside)
        
        
        
        
            //cell.workStartBtn.isHidden = true
        
        
//        else if checkIntValue == 4
//        {
//            cell.imgStatus.isHidden = true
//            cell.viewDetailsBtn.tag = 4
//             cell.viewDetailsBtn.addTarget(self, action: #selector(self.ViewDetailData(_:)) ,for: .touchUpInside)
//            cell.paymentStatusLabel.isHidden = true
//            cell.workStartBtn.isHidden = true
//        }
    
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  185
        
    }
    
    @objc func ViewDetailData(_ sender:UIButton){
        
        //let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        //SPIssueListVC
        // self.present(mvc, animated: true, completion: nil)

      
         if checkIntValue == "3"{
          
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
            gotoVC.orderIdToSee = requesterOrderIdArr[sender.tag]
            gotoVC.checkValue = self.checkIntValue ?? ""

            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
        else if checkIntValue == "5"{
            
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
            gotoVC.orderIdToSee = requesterOrderIdArr[sender.tag]
            gotoVC.checkValue = self.checkIntValue ?? ""
          self.navigationController?.pushViewController(gotoVC, animated: true)
            
            
        }
        
    }

    
   
    
}
