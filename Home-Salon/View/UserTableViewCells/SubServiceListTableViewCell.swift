//
//  SubServiceListTableViewCell.swift
//  HomeSalon_ServiceProvider_App
//
//  Created by Rajesh Kishanchand on 8/1/19.
//  Copyright © 2019 Volive Solutions. All rights reserved.
//

import UIKit

class SubServiceListTableViewCell: UITableViewCell {

    @IBOutlet var subServiceName_Label: UILabel!
    
    
    @IBOutlet weak var subServiceImg: UIImageView!
    
    
    @IBOutlet weak var btnselectedOrNot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
