//
//  OrderTypeListCell.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class OrderTypeListCell: UITableViewCell {

    
    @IBOutlet weak var visitDateTimeSt: UILabel!
    @IBOutlet weak var orderIdSt: UILabel!
    @IBOutlet weak var displayImg: UIImageView!
    @IBOutlet var paymentStatusLabel: UILabel!
    @IBOutlet var viewDetailsBtn: UIButton!
    @IBOutlet var workStartBtn: UIButton!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
