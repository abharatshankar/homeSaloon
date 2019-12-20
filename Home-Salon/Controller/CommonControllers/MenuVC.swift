//
//  MenuVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    
    @IBOutlet weak var createAccounBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet var showView: UIView!
    @IBOutlet var menuTV: UITableView!
    @IBOutlet weak var gradientView: UIView!
    
    var cell : MenuCell!
    var menuNamesArray = [String]()
    var checkIntValue:Int!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        name =  UserDefaults.standard.object(forKey: "userName") as? String ?? ""
        
        if name.count > 0
        {
        
          logInBtn.setTitle(name, for: UIControl.State.normal)
          createAccounBtn.setTitle("", for: UIControl.State.normal)
            logInBtn.isUserInteractionEnabled = false
            createAccounBtn.isUserInteractionEnabled = false
            
        }
        else
        {
            
            logInBtn.setTitle("Login /", for: UIControl.State.normal)
            createAccounBtn.setTitle("Create Account", for: UIControl.State.normal)
            logInBtn.isUserInteractionEnabled = true
            createAccounBtn.isUserInteractionEnabled = true
            
        }
       
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isHidden = true
//        menuTV.separatorColor = UIColor.clear
         menuTV.tableFooterView =  UIView.init(frame: CGRect.zero)
        
        //UserDefaults.standard.object(forKey: "")
        
        
    }
    
    
    @IBAction func languageChangeBtn(_ sender: Any) {
    }
    
    func setTableViewBackgroundGradient(sender: UITableView, _ topColor:UIColor, _ bottomColor:UIColor) {
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = sender.bounds
        let backgroundView = UIView(frame: sender.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.backgroundView = backgroundView
    }
    
   
    @IBAction func logInBtnTap(_ sender: Any)
    {
        let signup = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signup.userTypeString = "user"
        self.navigationController?.pushViewController(signup, animated: true)
    }
    
    
    @IBAction func createAccountBtnTap(_ sender: Any)
    {
        let signup = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPSignUpVC") as! SPSignUpVC
        signup.userTypeString = "user"
        self.navigationController?.pushViewController(signup, animated: true)
        
    }
    
    func setGradientBackground() {
        
        let colorTop =  UIColor(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 161.0/255.0, green: 144.0/255.0, blue: 129.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       // self.setTableViewBackgroundGradient(sender: menuTV, UIColor.init(red: 87.0/255.0, green: 96.0/255.0, blue: 124.0/255.0, alpha: 1.0), UIColor.init(red: 161.0/255.0, green: 144.0/255.0, blue: 129.0/255.0, alpha: 1.0))
      
       setGradientBackground()
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        if UserDefaults.standard.object(forKey: "type") as! String == "user"{
            menuNamesArray = ["HOME","REQUEST","ORDERS","NOTIFICATIONS","MY PROFILE","CONTACT US","TERMS AND CONDITIONS","SIGN OUT"]
        }else{
            menuNamesArray = ["HOME","REQUEST","PENDING","COMPLETE","REJECT","LIST OF SERVICES","NOTIFICATIONS","MY PROFILE","TERMS AND CONDITIONS","SIGN OUT"]
        }
        
        
        
    }
    
}


extension MenuVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = menuTV.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell
        cell.menuNameLabel.text = menuNamesArray[indexPath.row]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if UserDefaults.standard.object(forKey: "type") as! String == "user"{
            if indexPath.row == 0{
                
                let userHome = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeViewController1") as! UserHomeViewController
                self.navigationController?.pushViewController(userHome, animated: true)
            }
            else if indexPath.row == 1{
                
                let userRequests = self.storyboard?.instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
                userRequests.checkString = "Side"
                self.navigationController?.pushViewController(userRequests, animated: true)
            }
            else if indexPath.row == 2{
                
                let userOrders = self.storyboard?.instantiateViewController(withIdentifier: "UserOrdersViewController") as! UserOrdersViewController
                userOrders.checkString = "Side"
                self.navigationController?.pushViewController(userOrders, animated: true)
            }
            else if indexPath.row == 3{
                
                let userNotifications = self.storyboard?.instantiateViewController(withIdentifier: "UserNotificationsViewController") as! UserNotificationsViewController
                userNotifications.checkString = "Side"
                self.navigationController?.pushViewController(userNotifications, animated: true)
            }
            else if indexPath.row == 4{
                
                let userProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                userProfile.checkString = "Side"
                self.navigationController?.pushViewController(userProfile, animated: true)
            }
            else if indexPath.row == 5{
                let contactUs = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                self.navigationController?.pushViewController(contactUs, animated: true)
            }
            else if indexPath.row == 6{
                
                let TermsCondVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsCondVC") as! TermsCondVC
                self.navigationController?.pushViewController(TermsCondVC, animated: true)
            }else if indexPath.row == 7{
                
                let gateway = self.storyboard?.instantiateViewController(withIdentifier: "GatewayViewController") as! GatewayViewController
                
               
                UserDefaults.standard.removeObject(forKey: USER_ID)
                
                UserDefaults.standard.set("" as Any, forKey: "type2")
                UserDefaults.standard.set("" as Any, forKey: "userName")
                
                var  type =  UserDefaults.standard.set("" as Any, forKey: "type2")
                print(type)
                self.navigationController?.pushViewController(gateway, animated: true)
            }
         }else{
            if indexPath.row == 0{
                
                let SPHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "SPHomeVC") as! SPHomeVC
                self.navigationController?.pushViewController(SPHomeVC, animated: true)
            }
            else if indexPath.row == 1{
                
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
                //OrderTypeListVC.checkIntValue = 1
                self.navigationController?.pushViewController(OrderTypeListVC, animated: true)
            }
            else if indexPath.row == 2{
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingVC") as! PendingVC
               // OrderTypeListVC.checkIntValue = 2
                self.navigationController?.pushViewController(OrderTypeListVC, animated: true)
            }
                
                // complete
                
            else if indexPath.row == 3{
                
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                OrderTypeListVC.checkIntValue = "3"
                self.navigationController?.pushViewController(OrderTypeListVC, animated: true)
            }
                // reject
                
            else if indexPath.row == 4{
                
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                OrderTypeListVC.checkIntValue = "5"
                self.navigationController?.pushViewController(OrderTypeListVC, animated: true)
            }
            else if indexPath.row == 5{
                
                let ListOfServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ListOfServicesVC") as! ListOfServicesVC
                self.navigationController?.pushViewController(ListOfServicesVC, animated: true)
            }
            else if indexPath.row == 6{
                
                let NotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "SPNotificationsVC") as! SPNotificationsVC
                self.navigationController?.pushViewController(NotificationsVC, animated: true)
            }
            else if indexPath.row == 7{
                
                let ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "SPProfileViewController") as! SPProfileViewController
                self.navigationController?.pushViewController(ProfileViewController, animated: true)
            }
            else if indexPath.row == 8{
                
                let TermsCondVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsCondVC") as! TermsCondVC
                self.navigationController?.pushViewController(TermsCondVC, animated: true)
            }
            else if indexPath.row == 9{
                
                let gateway = self.storyboard?.instantiateViewController(withIdentifier: "GatewayViewController") as! GatewayViewController
                UserDefaults.standard.set("" as Any, forKey: "type2")
                UserDefaults.standard.removeObject(forKey: USER_ID)
                UserDefaults.standard.set("" as Any, forKey: "userName")
                var  type =  UserDefaults.standard.set("" as Any, forKey: "type2")
                print(type)
                self.navigationController?.pushViewController(gateway, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
}

