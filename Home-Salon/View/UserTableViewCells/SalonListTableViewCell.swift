//
//  SalonListTableViewCell.swift
//  Home-Salon
//
//  Created by volivesolutions on 31/07/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit

class SalonListTableViewCell: UITableViewCell {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var promotedLabel: UILabel!
    @IBOutlet var checkImageView: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var salonImg: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var wishListBtn: UIButton!
    
    @IBOutlet weak var serviceCostLbl: UILabel!
    @IBOutlet weak var serviceNameLbl: UILabel!
    
    @IBOutlet weak var priceOfService: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
