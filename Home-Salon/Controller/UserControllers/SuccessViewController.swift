//
//  SuccessViewController.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var orderNoLbl: UILabel!
    
    @IBOutlet weak var thankYouSt: UILabel!
    
    @IBOutlet weak var urPaymentCompletedSt: UILabel!
    
    var orderId = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderNoLbl.text = "Order No : " + orderId
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ordersBtnAction(_ sender: Any) {
        let orders = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsViewController") as! UserRequestsViewController
        orders.checkString = "Side"
        self.navigationController?.pushViewController(orders, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
