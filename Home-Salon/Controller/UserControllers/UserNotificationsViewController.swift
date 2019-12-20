//
//  UserNotificationsViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class UserNotificationsViewController: UIViewController {
    
    var checkString : String?
    var notificationText = [String]()
    var notificationTime = [String]()
    
    @IBOutlet var notificationsTableView: UITableView!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = languageChangeString(a_str: "Notifications")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
     
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId == ""
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
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
        else
        {
          notificationsData()
            
        }
    }
    
    
    
    
    @IBAction func backBtnTap(_ sender: Any)
    {
        
        if  self.checkString == "Side" {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    func notificationsData()
    {
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let notificationUrl = "\(base_path)services/notifications?"
            
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
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            if let notificationsData = responseData?["data"] as? [Dictionary<String, AnyObject>]
                            {
                                
                              for i in 0..<notificationsData.count
                              {
                                if let text = notificationsData[i]["text"]as? String
                                {
                                    self.notificationText.append(text)
                                }
                                if let time = notificationsData[i]["time"]as? String
                                {
                                    self.notificationTime.append(time)
                                 }
                               }
                                
                            }
                            
                            DispatchQueue.main.async {
                               
                                self.notificationsTableView.reloadData()
                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            
                            DispatchQueue.main.async {
                               
                                self.notificationsTableView.reloadData()
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
            self.showToastForAlert(message:languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            
        }
    }
    
   
}

extension UserNotificationsViewController: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        cell.notificationTextLbl.text = notificationText[indexPath.row]
        cell.notificationTimeLbl.text = notificationTime[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
