//
//  NotificationsCell.swift
//  SPScreen
//
//  Created by Suman Guntuka on 29/07/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {
    
    
    @IBOutlet weak var userPic: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var notificationTextLbl: UILabel!
    @IBOutlet weak var notificationTimeLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
