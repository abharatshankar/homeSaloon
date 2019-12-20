//
//  SPHomeVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import SideMenu

class SPHomeVC: UIViewController {

    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var ownerSalonName: UILabel!
    @IBOutlet weak var ownerNameLbl: UILabel!
    
    @IBOutlet weak var ownerExpLbl: UILabel!
    
    @IBOutlet var requestView: UIView!
    @IBOutlet var pendingView: UIView!
    @IBOutlet var completeView: UIView!
    @IBOutlet var scheduleView: UIView!
   @IBOutlet weak var reqSt: UILabel!
    
    @IBOutlet weak var scheduleSt: UILabel!
    @IBOutlet weak var pendingSt: UILabel!
    
    @IBOutlet weak var completeSt: UILabel!
    
    var checkValue : Int?
    
      let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestView.addShadow()
        pendingView.addShadow()
        scheduleView.addShadow()
        completeView.addShadow()
        
        self.navigationItem.title = languageChangeString(a_str: "Home Salon")
        
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
        menuLeftNavigationController.leftSide = true
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationDismissDuration = 0.2
        SideMenuManager.default.menuAnimationPresentDuration = 0.5
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuShadowRadius = 50
        SideMenuManager.default.menuShadowOpacity = 1
        SideMenuManager.default.menuWidth = 300
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
//        self.view_Requests.isUserInteractionEnabled = true
//        self.view_Reject.isUserInteractionEnabled = true
//        self.view_Pending.isUserInteractionEnabled = true
//        self.view_Completed.isUserInteractionEnabled = true
//        self.view_Wallet.isUserInteractionEnabled = true
        
        self.requestView.tag = 1
        self.pendingView.tag = 2
        self.completeView.tag = 3
        self.scheduleView.tag = 4
        self.requestView.addGestureRecognizer(tap)
        self.pendingView.addGestureRecognizer(tap1)
        self.completeView.addGestureRecognizer(tap2)
        self.scheduleView.addGestureRecognizer(tap3)
        
        self.reqSt.text = languageChangeString(a_str: "REQUEST")
        self.pendingSt.text = languageChangeString(a_str: "PENDING")
        self.completeSt.text = languageChangeString(a_str: "COMPLETE")
        self.scheduleSt.text = languageChangeString(a_str: "SCHEDULE")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
            self.userImg.layer.cornerRadius = 50
           self.userImg.layer.masksToBounds = true
        
        ownerSalonName.text = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
        if let image = UserDefaults.standard.object(forKey: "pic") as? String
        {
            self.userImg.sd_setImage(with: URL(string:image), placeholderImage:UIImage(named:""))
        }
       
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        
        
        if sender.view?.tag == 1 {
            
            //self.checkValue = 1
            
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
           
            gotoVC.checkStr1 = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
            
        }else if sender.view?.tag == 2{
            
            self.checkValue = 2
            
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingVC") as! PendingVC
            
           // gotoVC.checkIntValue = self.checkValue
            gotoVC.checkStr1 = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
        else if sender.view?.tag == 3{
            
            self.checkValue = 3
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
            
            gotoVC.checkIntValue = "3"
            gotoVC.checkStr = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
        else if sender.view?.tag == 4{
            
            self.checkValue = 4
            let ScheduleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
            
            //gotoVC.checkIntValue = self.checkValue
//            gotoVC.checkStr = "req"
            self.navigationController?.pushViewController(ScheduleViewController, animated: true)
            
        }
//        else if sender.view?.tag == 5{
//            
//            //self.checkValue = 4
//            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
//            
//            // gotoVC.checkIntValue = self.checkValue
//            //  gotoVC.checkStr = "req"
//            self.navigationController?.pushViewController(gotoVC, animated: true)
//            
//        }
        
    }
    
    
    @IBAction func menuBtnAction(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
    }
    
    @IBAction func notificationBtnAction(_ sender: Any) {
        let NotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "SPNotificationsVC") as! SPNotificationsVC
        NotificationsVC.checkStr = "home"
        self.navigationController?.pushViewController(NotificationsVC, animated: true)
    }
}


extension UIView {
    func addShadow(){
        self.layer.masksToBounds = false
        // self.layer.shadowColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50).cgColor
        self.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 30
        self.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
}
