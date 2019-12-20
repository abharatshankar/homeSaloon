//
//  NotificationsVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class SPNotificationsVC: UIViewController {
    
    var checkStr : String?
    var notificationTextArr = [String]()
    var notificationnameArr = [String]()
    var notificationTimeArr = [String]()
    var profileImagesArr = [String]()
    
    
    @IBOutlet weak var notificationTv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.title = "Notifications"
        self.navigationItem.title = languageChangeString(a_str:"Notifications")
        
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
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        
        if  self.checkStr == "home" {
            self.navigationController?.popViewController(animated: true)
            
        }
        else{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        notificationsData()
    }
    
    func notificationsData()
    {
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let notificationUrl = "\(base_path)services/notifications?"
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            //https://www.volive.in/spsalon/services/notifications?api_key=2382019&lang=en&user_id=80
            
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang" : language,"api_key":APIKEY,"user_id":userId]
            
            print(parameters)
            
            Alamofire.request(notificationUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        
                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String
                        
                        self.notificationnameArr.removeAll()
                        self.notificationTextArr.removeAll()
                        self.notificationTimeArr.removeAll()
                        self.profileImagesArr.removeAll()
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            if let notificationsData = responseData?["data"] as? [Dictionary<String, AnyObject>]
                            {
                                
                                for i in 0..<notificationsData.count
                                {
                                    if let text = notificationsData[i]["text"]as? String
                                    {
                                        self.notificationTextArr.append(text)
                                    }
                                    if let name = notificationsData[i]["time"]as? String
                                    {
                                        self.notificationTimeArr.append(name)
                                    }
                                    if let name = notificationsData[i]["name"]as? String
                                    {
                                        self.notificationnameArr.append(name)
                                    }
                                    
                                    if let profile_pic = notificationsData[i]["display_pic"]as? String
                                    {
                                        self.profileImagesArr.append(base_path+profile_pic)
                                    }
                                }
                                
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.notificationTv.reloadData()
                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            
                            DispatchQueue.main.async {
                                
                                self.notificationTv.reloadData()
                            }
                            
                        }
                    }
                    catch let error as NSError {
                        
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
    

}

extension SPNotificationsVC: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationTextArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationsCell
        
        cell.nameLbl.text = notificationTextArr[indexPath.row]
        cell.notificationTimeLbl.text = notificationTimeArr[indexPath.row]
        cell.textLbl.text = notificationnameArr[indexPath.row]
        cell.userPic.sd_setImage(with: URL(string:profileImagesArr[indexPath.row]), completed: nil)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
