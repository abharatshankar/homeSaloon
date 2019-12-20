//
//  UserRequestsTableViewCell.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class UserRequestsTableViewCell: UITableViewCell {
   
    @IBOutlet var viewInvoiceBtn: UIButton!
    @IBOutlet var salonImageView: UIImageView!
    @IBOutlet var statusValueLabel: UILabel!
    @IBOutlet weak var requestShopName: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var spStatusSt: UILabel!
    @IBOutlet weak var dateTimeSt: UILabel!
    @IBOutlet weak var orderNoSt: UILabel!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var stackViewBtn: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


