//
//  CreateInvoiceViewController.swift
//  Home-SalonSP
//
//  Created by volivesolutions on 29/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class CreateInvoiceViewController: UIViewController {

    @IBOutlet var descTextView: UITextView!
    
    @IBOutlet weak var NameSt: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTextView.layer.borderColor = UIColor.init(red: 234.0/255.0, green: 233.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        self.descTextView.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    https://www.volive.in/spsalon/services/update_order_status
    //    api_key:2382019
    //    lang:en
    //    owner_id:136
    //    order_id:172
    //    order_status:6

    
    

}
