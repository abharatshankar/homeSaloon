//
//  TermsCondVC.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class TermsCondVC: UIViewController {
    
    
    @IBOutlet weak var termsTv: UITextView!
    
    var checkStr : String?
    var termsConditions = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = languageChangeString(a_str:"Terms and Conditions")
        //self.title = "Terms and Conditions"
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
    
    override func viewWillAppear(_ animated: Bool) {
        termsAndConditions()
    }

    @objc func showLeftView(sender: AnyObject?) {
        
        if  self.checkStr == "terms" {
            self.navigationController?.popViewController(animated: true)
            
        }
        else{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        }
        
    }
    
    
    
    // terms and conditions
    
    func termsAndConditions()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
           
            let terms_conditions = "\(base_path)services/terms?"
            
            
            //    https://www.volive.in/spsalon/services/terms?api_key=2382019&lang=en
            //    Terms and Conditions (GET method)
            //
            //    api_key:2382019
            //    lang:en
    
            
           
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang":language ]
            
            Alamofire.request(terms_conditions, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    //print(responseData)
                    
                    let status = responseData["status"] as! Int
     
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if let responceData1 = responseData["data"] as? [String:AnyObject]
                        {
                            self.termsConditions = responceData1["terms"] as? String ?? ""
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.termsTv.text = self.termsConditions
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
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message:"Please ensure you have proper internet connection")
        }
        
    }
    
    
    
    
    
    
    

}
