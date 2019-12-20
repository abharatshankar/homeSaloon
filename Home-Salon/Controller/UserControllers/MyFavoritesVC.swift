//
//  MyFavoritesVC.swift
//  Home-Salon
//
//  Created by harshitha on 20/09/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class MyFavoritesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
 
    @IBOutlet weak var favoriteList: UITableView!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    var favouriteArr:[favouriteListData] = []
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = languageChangeString(a_str:"My Favorites")

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
        
        if userId == ""
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
            
            present(refreshAlert, animated: true, completion: nil)
        }
        else
        {
        
           favouriteList()
            
        }
        
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        
         self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return favouriteArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite", for: indexPath) as! SalonListTableViewCell
        cell.nameLbl.text = favouriteArr[indexPath.row].name
        //cell.ratingLbl.text = String(favouriteArr[indexPath.row].ratings)
        let imgStr = base_path+favouriteArr[indexPath.row].display_pic
        cell.salonImg.sd_setImage(with: URL (string: imgStr), placeholderImage:
            UIImage(named:""))
        
    return cell
            
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    

    func favouriteList()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let favouriteListUrl = "\(base_path)services/user_whishlists?"
           
            //    https://www.volive.in/spsalon/services/user_whishlists?api_key=2382019&lang=en&user_id=8
           
            let userId = UserDefaults.standard.object(forKey: "user_id") as? String ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang":language,"api_key":APIKEY,"user_id":userId]
            
            print(parameters)
            
            Alamofire.request(favouriteListUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result)
                {
                case .success(_):
                    
                    guard let data = response.data, response.result.error == nil else { return }
                    
                    do {
                        
                        let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
                        print(responseData)
                        self.favouriteArr.removeAll()
                        
                        let status = responseData?["status"] as! Int
                        let message = responseData?["message"] as! String
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            if let favouriteList = responseData?["data"] as? [Dictionary<String, AnyObject>]
                            {
                                
                                if (favouriteList.count)>0{
                                    
                                    for i in favouriteList{
                                        
                                        let newData = favouriteListData(name: (i["name"] as! String), display_pic: (i["display_pic"] as! String), location: (i["location"] as! String))
                                      
                                        self.favouriteArr.append(newData)
                                    }
                                    
                                }
                                
                            }
                            
                            DispatchQueue.main.async {
                                self.favoriteList.reloadData()
                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message)
                            
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

struct favouriteListData{
    
    var name: String!
    var display_pic: String!
    var location: String!
    //var ratings:Int!
    init(name:String,display_pic:String,location:String) {
        
        
        self.name  = name
        self.display_pic  = display_pic
        self.location  = location
        //self.ratings = rating
        
    }
   
    
}
