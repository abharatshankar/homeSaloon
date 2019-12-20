//
//  AccountVerificationViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 01/08/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class AccountVerificationViewController: UIViewController {

    @IBOutlet weak var youraccountSt: UILabel!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youraccountSt.text = languageChangeString(a_str: "Your account is under verification,Please wait for admin approval")
        
      // Do any additional setup after loading the view.
    }
    

    @IBAction func tapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name("navigate1"), object: nil)
    }
   
    
}
