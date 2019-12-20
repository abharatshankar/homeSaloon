//
//  UserOrdersTableViewCell.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class UserOrdersTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var orderStatusSt: UILabel!
    @IBOutlet weak var dateTimeSt: UILabel!
    @IBOutlet weak var orderNoSt: UILabel!
    
    @IBOutlet weak var servicePriceLbl: UILabel!
   
    @IBOutlet weak var serviceNameLbl: UILabel!
    
    @IBOutlet var salonImageView: UIImageView!
    @IBOutlet var statusValueLabel: UILabel!
    
    @IBOutlet var viewDetailsBtn: UIButton!
    @IBOutlet var ratingBtn: UIButton!
    
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var providerNameLbl: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
